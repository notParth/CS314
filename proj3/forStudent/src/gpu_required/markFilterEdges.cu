/*
 **********************************************
 *  CS314 Principles of Programming Languages *
 *  Fall 2020                                 *
 **********************************************
 */
#include <stdio.h>
#include <stdlib.h>

__global__ void markFilterEdges_gpu(int * src, int * dst, int * matches, int * keepEdges, int numEdges) {
	/** YOUR CODE GOES BELOW **/
	int num_threads = blockDim.x * gridDim.x;;
	int tid = blockDim.x * blockIdx.x + threadIdx.x;
	for (int i = tid; i < numEdges; i+=num_threads) 
	{
		if(matches[src[i]] == -1 && matches[dst[i]] == -1)
			keepEdges[i] = 1;
		else
			keepEdges[i] = 0;
	}
	/** YOUR CODE GOES ABOVE **/
}
