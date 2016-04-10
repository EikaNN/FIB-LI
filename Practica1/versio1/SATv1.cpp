#include <iostream>
#include <stdlib.h>
#include <algorithm>
#include <vector>
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

// structs
struct Variable {
  VI positiveLit;
  VI negativeLit;
  LL count;
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
  for (uint i = 1; i <= numVars; ++i) variables[i].count = 0;
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
  for (uint i = 0; i < numClauses; ++i) {
    int lit;
    for (uint j = 0; j < CLAUSE_SIZE; ++j) {
      cin >> lit;
      clauses[i].push_back(lit);
      if (lit > 0) {variables[lit].positiveLit.push_back(i); ++variables[lit].count;}
      else {variables[-lit].negativeLit.push_back(i); ++variables[-lit].count;}
    }
    cin >> lit; //Read last 0
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
    else if (not someLitTrue and numUndefs == 1) setLiteralToTrue(lastLitUndef);  
  }
  return false;
} 

bool propagateGivesConflict() {
  while ( indexOfNextLitToPropagate < modelStack.size() ) {
    int lit = modelStack[indexOfNextLitToPropagate];
    ++indexOfNextLitToPropagate;
    ++numPropagations;
    if (lit < 0) {
      if (propagateLitConflict(variables[-lit].positiveLit)) return true;
    }
    else {
      if (propagateLitConflict(variables[lit].negativeLit)) return true;
    }
  }
  return false;
}

void backtrack() {
  uint i = modelStack.size() -1;
  int lit = 0;
  while (modelStack[i] != 0){ // 0 is the DL mark
    lit = modelStack[i];
    model[abs(lit)] = UNDEF;
    modelStack.pop_back();
    --i;
  }
  // at this point, lit is the last decision
  modelStack.pop_back(); // remove the DL mark
  --decisionLevel;
  indexOfNextLitToPropagate = modelStack.size();
  setLiteralToTrue(-lit);  // reverse last decision
}


// Heuristic for finding the next decision literal:
int getNextDecisionLiteral() {
  for (uint i = 1; i <= numVars; ++i) // stupid heuristic:
    if (model[i] == UNDEF) return i;  // returns first UNDEF var, positively
  return 0; // returns 0 when all literals are defined
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
      if ( decisionLevel == 0) { 
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
