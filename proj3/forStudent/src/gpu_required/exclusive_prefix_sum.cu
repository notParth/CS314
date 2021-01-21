/*
 **********************************************
 *  CS314 Principles of Programming Languages *
 *  Fall 2020                                 *
 **********************************************
 */
#include <stdio.h>
#include <stdlib.h>

__global__ void exclusive_prefix_sum_gpu(int * oldSum, int * newSum, int distance, int numElements) {
	/** YOUR CODE GOES BELOW **/
	int num_threads = blockDim.x * gridDim.x;
	int tid = blockDim.x * blockIdx.x + threadIdx.x;
	
	for(int i = tid; i < numElements; i+=num_threads)
	{
		if (distance == 0)
		{
			if(i==0)
				newSum[0] = 0;
			else
				newSum[i] = oldSum[i - 1];
		}
	
		else	
		{
	
			if(i >= distance)
				newSum[i] = oldSum[i - distance] + oldSum[i];
			else
				newSum[i] = oldSum[i];
		}
	}
	
	/** YOUR CODE GOES ABOVE **/
}
