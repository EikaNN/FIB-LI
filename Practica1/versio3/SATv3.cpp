#include <iostream>
#include <stdlib.h>
#include <algorithm>
#include <vector>
#include <queue>
using namespace std;

// defines
#define UNDEF -1
#define TRUE 1
#define FALSE 0
#define CLAUSE_SIZE 3

// typedefs
typedef long long LL;
typedef vector<int> VI;
typedef vector<VI> VVI;
typedef vector<LL> VLL;

// structs
struct Variable {
  VI posLit;              // clauses where variable appears as positive litteral
  VI negLit;              // clauses where variable appears as negative litteral
  VLL act;                // heurisitic: activity of this variable
};

uint numVars;
uint numClauses;
VVI clauses;
VI model;
VI modelStack;
uint indexOfNextLitToPropagate;
uint decisionLevel;

LL numPropagations;
LL numDecisions;
vector<Variable> variables;


void initialize() {
  clauses.resize(numClauses);
  model.resize(numVars+1,UNDEF);
  variables.resize(numVars+1);
  indexOfNextLitToPropagate = 0;  
  decisionLevel = 0;
  numDecisions = 0;
  numPropagations = 0;  
}

void readClauses() {
  // Skip comments
  char c = cin.get();
  while (c == 'c') {
    while (c != '\n') c = cin.get();
    c = cin.get();
  }  
  // Read "cnf numVars numClauses"
  string aux;
  cin >> aux >> numVars >> numClauses;
  initialize();
  // Read clauses
  for (int i = 0; i < numClauses; ++i) {
    int lit;
    for (int j = 0; j < CLAUSE_SIZE; ++j) {
      cin >> lit;
      clauses[i].push_back(lit);
      if (lit > 0) variables[lit].posLit.push_back(i);
      else variables[-lit].negLit.push_back(i);
    }
    cin >> lit; //Read last 0
  }
  for (int i = 1; i <= numVars; ++i) {
    int iniScore = 10*variables[i].posLit.size() + 10*variables[i].negLit.size();
    variables[i].act.push_back(iniScore); 
  }   
}


inline int currentValueInModel(int lit) {
  if (lit >= 0) return model[lit];
  else {
    if (model[-lit] == UNDEF) return UNDEF;
    else return 1 - model[-lit];
  }
}


inline void setLiteralToTrue(int lit) {
  modelStack.push_back(lit);
  if (lit > 0) model[lit] = TRUE;
  else model[-lit] = FALSE;		
}

bool propagateLitConflict(const VI& clauseList) {
  for (int i = 0; i < clauseList.size(); ++i) {
    int c = clauseList[i];
    bool someLitTrue = false;
    int numUndefs = 0;
    int lastLitUndef = 0;
    for (int j = 0; not someLitTrue and j < CLAUSE_SIZE; ++j) {
      int val = currentValueInModel(clauses[c][j]);
      if (val == TRUE) someLitTrue = true;
      else if (val == UNDEF){ ++numUndefs; lastLitUndef = clauses[c][j]; }
    }
    if (not someLitTrue and numUndefs == 0) return true; // conflict!

    // increase activity if remaining 2 lits are UNDEF
    if (numUndefs == 2) {
      for (int j = 0; j < CLAUSE_SIZE; ++j) {
        int val = currentValueInModel(clauses[c][j]);
        if (val == UNDEF) variables[abs(clauses[c][j])].act[decisionLevel] += 5;
      }
    }
    else if (not someLitTrue and numUndefs == 1) setLiteralToTrue(lastLitUndef);
  }  
  return false;
}

void decreaseActivity(const VI& clauseList) {
  for (int i = 0; i < clauseList.size(); ++i) {
    int c = clauseList[i];
    for (int j = 0; j < CLAUSE_SIZE; ++j) {
      int val = currentValueInModel(clauses[c][j]);
      if (val == UNDEF) variables[abs(clauses[c][j])].act[decisionLevel] -= 10;
    }
  }
} 

bool propagateGivesConflict() {
  while ( indexOfNextLitToPropagate < modelStack.size() ) {
    int lit = modelStack[indexOfNextLitToPropagate];
    ++indexOfNextLitToPropagate;
    ++numPropagations;
    if (lit < 0) {
      decreaseActivity(variables[-lit].negLit);
      if (propagateLitConflict(variables[-lit].posLit)) return true;
    }
    else {
      decreaseActivity(variables[lit].posLit);
      if (propagateLitConflict(variables[lit].negLit)) return true;
    }
  }
  return false;
}

void backtrack() {
  uint i = modelStack.size() -1;
  int lit = 0;
  while (modelStack[i] != 0) { // 0 is the DL mark
    lit = modelStack[i];
    model[abs(lit)] = UNDEF;
    modelStack.pop_back();
    --i;
  }

  for (int i = 1; i <= numVars; ++i) variables[i].act.pop_back();

  // at this point, lit is the last decision
  modelStack.pop_back(); // remove the DL mark
  --decisionLevel;
  indexOfNextLitToPropagate = modelStack.size();
  setLiteralToTrue(-lit);  // reverse last decision
}


// Heuristic for finding the next decision literal:
int getNextDecisionLiteral() {
  int var = 0;
  LL max = -1231321313;
  for (int i = 1; i <= numVars; ++i) {
    variables[i].act.push_back(variables[i].act[decisionLevel]);
    if (model[i] == UNDEF and variables[i].act[decisionLevel] > max) {
      var = i;
      max = variables[var].act[decisionLevel];
    }
  }
  if (var == 0) return 0; // returns 0 when all literals are defined 

  if (variables[var].posLit.size() > variables[var].negLit.size()) return var;
  else return -var; 
}

void checkmodel() {
  for (int i = 0; i < numClauses; ++i) {
    bool someTrue = false;
    for (int j = 0; not someTrue and j < clauses[i].size(); ++j)
      someTrue = (currentValueInModel(clauses[i][j]) == TRUE);
    if (not someTrue) {
      cout << "Error in model, clause is not satisfied:";
      for (int j = 0; j < clauses[i].size(); ++j) cout << clauses[i][j] << " ";
      cout << endl;
      exit(1);
    }
  }  
}

int main() { 
  readClauses(); // reads numVars, numClauses and clauses

  // Take care of initial unit clauses, if any
  for (uint i = 0; i < numClauses; ++i)
    if (clauses[i].size() == 1) {
      int lit = clauses[i][0];
      int val = currentValueInModel(lit);
      if (val == FALSE) {cout << "UNSATISFIABLE" << endl; return 10;}
      else if (val == UNDEF) setLiteralToTrue(lit);
    }
  
  // DPLL algorithm
  while (true) {
    while ( propagateGivesConflict() ) {
      if ( decisionLevel == 0 ) { 
      	cout << "Decisions: " << numDecisions << endl;
      	cout << "Propagations: " << numPropagations << endl;
      	cout << "UNSATISFIABLE" << endl; 
      	return 10; 
      }
      backtrack();
    }
    int decisionLit = getNextDecisionLiteral();
    if (decisionLit == 0) { 
    	checkmodel(); 
    	cout << "Decisions: " << numDecisions << endl;
      cout << "Propagations: " << numPropagations << endl;
      cout << "SATISFIABLE" << endl; 
    	return 20; 
    }
    // start new decision level:
    modelStack.push_back(0);  // push mark indicating new DL
    ++indexOfNextLitToPropagate;
    ++decisionLevel;
    ++numDecisions;
    setLiteralToTrue(decisionLit);    // now push decisionLit on top of the mark
  }
}  
