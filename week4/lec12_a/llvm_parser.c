#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <llvm-c/Core.h>
#include <llvm-c/IRReader.h>
#include <llvm-c/Types.h>

#define prt(x) if(x) { printf("%s\n", x); }

LLVMModuleRef createLLVMModel(char * filename){
	char *err = 0;

	LLVMMemoryBufferRef ll_f = 0;
	LLVMModuleRef m = 0;

	LLVMCreateMemoryBufferWithContentsOfFile(filename, &ll_f, &err);

	if (err != NULL) { 
		prt(err);
		return NULL;
	}
	
	LLVMParseIRInContext(LLVMGetGlobalContext(), ll_f, &m, &err);

	if (err != NULL) {
		prt(err);
	}

	return m;
}

void walkBBInstructions(LLVMBasicBlockRef bb){
	for (LLVMValueRef instruction = LLVMGetFirstInstruction(bb); instruction;
  				instruction = LLVMGetNextInstruction(instruction)) {
	
		//LLVMGetInstructionOpcode gives you LLVMOpcode that is a enum		
		LLVMOpcode opcode = LLVMGetInstructionOpcode(instruction);
    // print the number of operands for the instruction
    int numOperands = LLVMGetNumOperands(instruction);
    printf("Number of operands: %d\n", numOperands);
    
    // find the operands of the instruction
    // LLVMValueRef *operands = calloc(numOperands, sizeof(LLVMValueRef));
    // LLVMGetMDNodeOperands(instruction, operands);

    // print operands only when they are integer constants
    // LLVMTypeRef LLVMGetGEPSourceElementType(LLVMValueRef GEP);

    bool allOperandsAreConstants = true;
    for (uint i = 0; i < numOperands; ++i) {
      LLVMValueRef operand = LLVMGetOperand(instruction, i);
      if (LLVMIsAConstantInt(operand)) {
        printf("Const int operand at index %d: %lld\n", i, LLVMConstIntGetSExtValue(operand));
      } 
      else {
        allOperandsAreConstants = false;
      }
    }
    if (allOperandsAreConstants) {
      printf("all operands are const for instruction:\n");
      LLVMDumpValue(instruction);
      printf("\n");
    }

		//if (op == LLVMCall) //Type of instruction can be checked by checking op
		//if (LLVMIsACallInst(instruction)) //Type of instruction can be checked by using macro defined IsA functions
		//{
		/**
      Use the code in llvm_parser.c to do the following:
      Prints the number of operands for each instruction
      Find the operands of the instruction (be ready to be surprised)
      Prints operands only when they are integer constants
      Print instructions when all operands are constants
		 * 
		 */

	}

}


void walkBasicblocks(LLVMValueRef function){
	for (LLVMBasicBlockRef basicBlock = LLVMGetFirstBasicBlock(function);
 			 basicBlock;
  			 basicBlock = LLVMGetNextBasicBlock(basicBlock)) {
		
		printf("\nIn basic block\n");
		walkBBInstructions(basicBlock);
	
	}
}

void walkFunctions(LLVMModuleRef module){
	for (LLVMValueRef function =  LLVMGetFirstFunction(module); 
			function; 
			function = LLVMGetNextFunction(function)) {

		const char* funcName = LLVMGetValueName(function);	

		printf("\nFunction Name: %s\n", funcName);

		walkBasicblocks(function);
 	}
}

void walkGlobalValues(LLVMModuleRef module){
	for (LLVMValueRef gVal =  LLVMGetFirstGlobal(module);
                        gVal;
                        gVal = LLVMGetNextGlobal(gVal)) {

                const char* gName = LLVMGetValueName(gVal);
                printf("Global variable name: %s\n", gName);
        }
}

int main(int argc, char** argv)
{
	LLVMModuleRef m;

	if (argc == 2){
		m = createLLVMModel(argv[1]);
	}
	else{
		m = NULL;
		return 1;
	}

	if (m != NULL){
		//LLVMDumpModule(m);
		walkFunctions(m);
	}
	else {
	    printf("m is NULL\n");
	}
	
	return 0;
}
