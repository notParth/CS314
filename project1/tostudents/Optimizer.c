#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include "InstrUtils.h"
#include "Utils.h"
int check(int arr[], int size, int key){
	for(int i = 0; i < size; i++){
		if(arr[i] == key)
			return i;
	}
	return -1;
}
int main()
{
	Instruction *head, *current;

	head = ReadInstructionList(stdin);
	if (!head) {
		WARNING("No instructions\n");
		exit(EXIT_FAILURE);
	}
	
	current = head;
	while (current->next != NULL){
		current = current->next;
	}
	int id[50], size = 0, index;
	while(current->prev != NULL){
		switch(current->opcode){
			case WRITE:
				id[size++] = current->field1;
				current->critical = 'y';
				break;
			case READ:
				index = check(id, size, current->field1);
				if (index > -1)
					id[index] = -999;
				current->critical = 'y';
				break;
			case LOAD:
			case STORE:
				index = check(id, size, current->field1);
				if(index > -1){
					id[index] = current->field2;
					current->critical = 'y';
				}
				else{
					current->critical = 'n';
				}
				break;
			case LOADI:
				index = check(id, size, current->field1);
				if(index > -1){
					id[index] = -999;
					current->critical = 'y';
				}
				else{
					current->critical = 'n';
				}
				break;
			case ADD:
			case SUB:
			case MUL:
			case AND:
			case XOR:
				index = check(id, size, current->field1);
				if(index > -1){
					id[index] = current->field2;
					id[size++] = current->field3;
					current->critical = 'y';
				}
				else
					current->critical = 'n';
				break;
		}
		current = current->prev;
	}
	current = head;
	while(current->next != NULL){
		Instruction *prev, *next, *temp;
		if((current->critical) == 'n'){
			temp = current;
			next = current->next;
			prev = current->prev;

			prev->next = next;
			next->prev = prev;
			current = next;

			temp->next = NULL;
			temp->prev = NULL;
			free(temp);
		}
		else
			current = current->next;
	}
	if (head) {
		PrintInstructionList(stdout, head);
		DestroyInstructionList(head);
	}
	return EXIT_SUCCESS;
}

