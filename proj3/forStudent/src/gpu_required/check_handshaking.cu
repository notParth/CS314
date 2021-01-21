/*
 **********************************************
 *  CS314 Principles of Programming Languages *
 *  Fall 2020                                 *
 **********************************************
 */
#include <stdio.h>
#include <stdlib.h>

__global__ void check_handshaking_gpu(int * strongNeighbor, int * matches, int numNodes) {
	/** YOUR CODE GOES BELOW **/
	int num_threads = blockDim.x * gridDim.x;
	int tid = blockDim.x * blockIdx.x + threadIdx.x;
	for (int i = tid; i < numNodes; i+= num_threads) 
	{
		if(matches[i] == -1){
			if(strongNeighbor[strongNeighbor[i]] == i){ 
				if( matches[strongNeighbor[i]] == -1){
					matches[i] = strongNeighbor[i];
					matches[strongNeighbor[i]] = i;
				}		
			}
		}
	}
	/** YOUR CODE GOES ABOVE **/
}
