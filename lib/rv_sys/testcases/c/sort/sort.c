//Modified based on: https://www.geeksforgeeks.org/quick-sort/
/* C implementation QuickSort */
#include "util.h"
#include "sort_ds.h"

// A utility function to swap two elements
void swap(int* a, int* b)
{
	int t = *a;
	*a = *b;
	*b = t;
}

/* This function takes last element as pivot, places
the pivot element at its correct position in the sorted
array, and places all smaller (smaller than pivot)
to left of pivot and all greater elements to right
of pivot */
int partition (int arr[], int low, int high)
{
	int pivot = arr[high]; // pivot
	int i = (low - 1); // Index of smaller element

	for (int j = low; j <= high- 1; j++)
	{
		// If current element is smaller than the pivot
		if (arr[j] < pivot)
		{
			i++; // increment index of smaller element
			swap(&arr[i], &arr[j]);
		}
	}
	swap(&arr[i + 1], &arr[high]);
	return (i + 1);
}

/* The main function that implements QuickSort
arr[] --> Array to be sorted,
low --> Starting index,
high --> Ending index */
void quickSort(int arr[], int low, int high)
{
	if (low < high)
	{
		/* pi is partitioning index, arr[p] is now
		at right place */
		int pi = partition(arr, low, high);

		// Separately sort elements before
		// partition and after partition
		quickSort(arr, low, pi - 1);
		quickSort(arr, pi + 1, high);
	}
}

//verfify from: https://github.com/riscv/riscv-tests
static int verify(int n, const volatile int* test, const int* verify)
{
	int i;
	// Unrolled for faster verification
	for (i = 0; i < n/2*2; i+=2)
	{
		int t0 = test[i], t1 = test[i+1];
		int v0 = verify[i], v1 = verify[i+1];
		if (t0 != v0) return i+1;
		if (t1 != v1) return i+2;
	}
	if (n % 2 != 0 && test[n-1] != verify[n-1])
		return n;
	return 0;
}


// Driver program to test above functions
int main()
{
	int n = sizeof(input_data)/sizeof(input_data[0]);
	quickSort(input_data, 0, n-1);
	int status=42;
	status=verify( DATA_SIZE, input_data, verify_data );
	if(status==0){
		puts("Sorting successfully completed.\n");
	}
	else{
		puts("Sorting unsuccessful.\n");
	}
	return status;
}

