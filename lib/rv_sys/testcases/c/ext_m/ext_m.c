#include "util.h"
#include "ext_m_ds.h"
#include <stdint.h>

#define tests 8

inline int32_t mulh(int32_t a, int32_t b) {
		int32_t result;
		asm volatile (
			"mulh %0, %1, %2"
			: "=r" (result)
			: "r" (a), "r" (b)
		);
	return result;
}

inline uint32_t mulhu(uint32_t a, uint32_t b) {
		uint32_t result;
		asm volatile (
			"mulhu %0, %1, %2"
			: "=r" (result)
			: "r" (a), "r" (b)
		);
	return result;
}

inline int32_t mulhsu(int32_t a, uint32_t b) {
		int32_t result;
		asm volatile (
			"mulhsu %0, %1, %2"
			: "=r" (result)
			: "r" (a), "r" (b)
		);
	return result;
}

int main(int argc, char* argv[])
{
	int i, a, b;
	int result[tests];
	int fail = 0;
	char *instr[tests] = {"div", "divu", "rem", "remu", "mul", "mulh", "mulhu", "mulhsu"};

	for (i = 0; i < tests; i++) {
		result[i] = 0;
	}

	for (i = 0; i < DATA_SIZE; i++) {
		a = in_data1[i];
		b = in_data2[i];
		if(div_ref[i] != a / b) result[0] = 1;
		if(divu_ref[i] != (uint32_t) a / (uint32_t) b) result[1] = 1;
		if(rem_ref[i] != a % b) result[2] = 1;
		if(remu_ref[i] != (uint32_t) a % (uint32_t) b) result[3] = 1;
		if(mul_ref[i] != a * b) result[4] = 1;
		if(mulh_ref[i] != mulh(a, b)) result[5] = 1;
		if(mulhu_ref[i] != mulhu(a, b)) result[6] = 1;
		if(mulhsu_ref[i] != mulhsu(a, b)) result[7] = 1;
	}

	for (i = 0; i < tests; i++) {
		if(result[i] == 1) fail++;
	}

	if (fail == 0) {
		puts("ext_m checks successfully completed.\n");

	}
	else {
		puts("ext_m checks unsuccessful.\n");
		for (i = 0; i < tests; i++) {
			if(result[i] == 1) puts(instr[i]);
		}
	}

	return fail;
}
