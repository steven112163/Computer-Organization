//-------------------------------------------------
// Subject: Lab5 - direct_mapped_cache_lru_bonus
//-------------------------------------------------
// Writer: 0510002 °Kà±³Ô 0510009 ±ià±¸© 
//-------------------------------------------------

#include <iostream>
#include <stdio.h>
#include <cmath>
#include <vector>

using namespace std;

struct valid_tag_lru {
	bool v;
	unsigned int tag;
	unsigned int lru;
};

struct cache_content_eight_way {
	valid_tag_lru validAndTagAndLRU[8];
};

const int K = 1024;

double log2(double n);
void simulate(char* argv[]);
void getDataAB(cache_content_eight_way* cache, const unsigned int& index, const unsigned int& tag, int& stallCycleA, int& stallCycleB);
void getDataC(cache_content_eight_way* cacheL1, cache_content_eight_way* cacheL2, const unsigned int& indexL1, const unsigned int& tagL1, const unsigned int& indexL2, const unsigned int& tagL2, int& stallCycle);

int main(int argc, char* argv[]) {
	// Let us simulate 0.5KB cache with 32B blocks
	if (argc == 3)
		simulate(argv);
	else
		cout << "Error" << endl;

	return 0;
}

double log2(double n) {
	// log(n) / log(2) is log2.
	return log(n) / log(double(2));
}

void simulate(char* argv[]) {
	unsigned int x;

	// 512B cache, 8-word block, 8-way
	int offset = (int)log2(32);
	int index = (int)(log2(512 / 32) - 3);
	int set = 512 / 32 / 8;
	// 128B cache, 4-word block, 8-way
	int offsetL1 = (int)log2(16);
	int indexL1 = (int)(log2(128 / 16) - 3);
	int setL1 = 128 / 16 / 8;
	// 4KB cache, 32-word block, 8-way
	int offsetL2 = (int)log2(128);
	int indexL2 = (int)(log2(4096 / 128) - 3);
	int setL2 = 4096 / 128 / 8;

	cache_content_eight_way *cache = new cache_content_eight_way[set];
	cache_content_eight_way *cacheL1 = new cache_content_eight_way[setL1];
	cache_content_eight_way *cacheL2 = new cache_content_eight_way[setL2];

	for (int i = 0; i < set; i++)
		for (int j = 0; j < 8; j++) {
			cache[i].validAndTagAndLRU[j].v = false;
			cache[i].validAndTagAndLRU[j].lru = j;
		}

	for (int i = 0; i < setL1; i++)
		for (int j = 0; j < 8; j++) {
			cacheL1[i].validAndTagAndLRU[j].v = false;
			cacheL1[i].validAndTagAndLRU[j].lru = j;
		}

	for (int i = 0; i < setL2; i++)
		for (int j = 0; j < 8; j++) {
			cacheL2[i].validAndTagAndLRU[j].v = false;
			cacheL2[i].validAndTagAndLRU[j].lru = j;
		}

	FILE *fp = fopen(argv[1], "r");  // read file

	// get address
	fscanf(fp, "%x", &x);
	unsigned int addressA = x;
	fscanf(fp, "%x", &x);
	unsigned int addressB = x;
	fscanf(fp, "%x", &x);
	unsigned int addressC = x;

	//get m, n, p
	fscanf(fp, "%d", &x);
	unsigned int m = x;
	fscanf(fp, "%d", &x);
	unsigned int n = x;
	fscanf(fp, "%d", &x);
	unsigned int p = x;

	vector<vector<unsigned int> > matrixA, matrixB, matrixC;
	// create matrixC
	for (int i = 0; i < m; i++) {
		vector<unsigned int>* col = new vector<unsigned int>;
		for (int j = 0; j < p; j++)
			col->push_back(0);
		matrixC.push_back(*col);
	}

	//get matrixA
	for (int i = 0; i < m; i++) {
		vector<unsigned int>* col = new vector<unsigned int>;
		for (int j = 0; j < n; j++) {
			fscanf(fp, "%d", &x);
			col->push_back(x);
		}
		matrixA.push_back(*col);
	}

	//get matrixB
	for (int i = 0; i < n; i++) {
		vector<unsigned int>* col = new vector<unsigned int>;
		for (int j = 0; j < p; j++) {
			fscanf(fp, "%d", &x);
			col->push_back(x);
		}
		matrixB.push_back(*col);
	}


	int programExecutionCycle = 0;
	int stallCycle1A = 0, stallCycle1B = 0, stallCycle1C = 0;
	// compute matrix multiplication
	programExecutionCycle += 5;
	// addi $1, $0, 4
	// addi $3, $0, 0
	// loop_i: slt $6, $3, $21
	// beq $6, $0, exit
	for (int i = 0; i < m; i++) {
		programExecutionCycle += 3;
		// addi $4, $0, 0
		// loop_j: slt $6, $4, $23
		// beq $6, $0, end_j
		for (int j = 0; j < p; j++) {
			programExecutionCycle += 3;
			unsigned int temp1 = 0;
			// addi $5, $0, 0
			// addi $10, $0, 0
			// loop_k: slt $6, $5, $22
			// beq $6, $0, end_k
			for (int k = 0; k < n; k++) {
				unsigned int temp2 = 4 * (i*n + k) + addressA;
				programExecutionCycle += 5;
				// mul $11, $3, $22
				// addu $12, $11, $5
				// mul $12, $12, $1
				// addu $13, $12, $24
				// lw $14, 0($13)

				unsigned int temp3 = 4 * (k*p + j) + addressB;
				programExecutionCycle += 5;
				// mul $15, $5, $23
				// addu $16, $15, $4
				// mul $16, $16, $1
				// addu $17, $16, $25
				// lw $18, 0($17)

				temp1 += (matrixA[i][k] * matrixB[k][j]);
				programExecutionCycle += 2;
				// mul $19, $18, $14
				// addu $10, $10, $19

				getDataAB(cache, (temp2 >> offset) & (set - 1),
					temp2 >> (index + offset),
					stallCycle1A, stallCycle1B);
				getDataAB(cache, (temp3 >> offset) & (set - 1),
					temp3 >> (index + offset),
					stallCycle1A, stallCycle1B);

				getDataC(cacheL1, cacheL2,
					(temp2 >> offsetL1) & (setL1 - 1),
					temp2 >> (indexL1 + offsetL1),
					(temp2 >> offsetL2) & (setL2 - 1),
					temp2 >> (indexL2 + offsetL2), stallCycle1C);
				getDataC(cacheL1, cacheL2,
					(temp3 >> offsetL1) & (setL1 - 1),
					temp3 >> (indexL1 + offsetL1),
					(temp3 >> offsetL2) & (setL2 - 1),
					temp3 >> (indexL2 + offsetL2), stallCycle1C);

				programExecutionCycle += 4;
				// addi $5, $5, 1
				// j loop_k
				// loop_k: slt $6, $5, $22
				// beq $6, $0, end_k
			}
			matrixC[i][j] = temp1;
			programExecutionCycle += 5;
			// end_k: mul $7, $3, $23
			// addu $8, $7, $4
			// mul $8, $8, $1
			// addu $9, $8, $26
			// sw $10, 0($9)

			unsigned int temp4 = 4 * (i*p + j) + addressC;

			getDataAB(cache, (temp4 >> offset) & (set - 1),
				temp4 >> (index + offset),
				stallCycle1A, stallCycle1B);

			getDataC(cacheL1, cacheL2,
				(temp4 >> offsetL1) & (setL1 - 1),
				temp4 >> (indexL1 + offsetL1),
				(temp4 >> offsetL2) & (setL2 - 1),
				temp4 >> (indexL2 + offsetL2), stallCycle1C);

			programExecutionCycle += 4;
			// addi $4, $4, 1
			// j loop_j
			// loop_j: slt $6, $4, $22
			// beq $6, $0, end_j
		}
		programExecutionCycle += 4;
		// end_j: addi $3, $3, 1
		// j loop_i
		// loop_i: slt $6, $3, $21
		// beq $6, $0, exit
	}
	// exit:
	fclose(fp);


	fp = fopen(argv[2], "w");  //write file
	for (int i = 0; i < m; i++) {
		for (int j = 0; j < p; j++) {
			fprintf(fp, "%d ", matrixC[i][j]);
		}
		fprintf(fp, "\n");
	}
	fprintf(fp, "%d %d %d %d\n", programExecutionCycle, stallCycle1A, stallCycle1B, stallCycle1C);
	fclose(fp);

	delete[] cache;
	delete[] cacheL1;
	delete[] cacheL2;
}

void getDataAB(cache_content_eight_way* cache, const unsigned int& index, const unsigned int& tag, int& stallCycleA, int& stallCycleB) {
	bool hit = false;
	for (int i = 0; i < 8; i++) {
		if (cache[index].validAndTagAndLRU[i].v && cache[index].validAndTagAndLRU[i].tag == tag) {
			cache[index].validAndTagAndLRU[i].v = true;  // hit
			int lastLRU = cache[index].validAndTagAndLRU[i].lru;
			cache[index].validAndTagAndLRU[i].lru = 7;
			for (int j = 0; j < 8; j++)
				if (j != i && cache[index].validAndTagAndLRU[j].lru > lastLRU)
					--cache[index].validAndTagAndLRU[j].lru;
			hit = true;
			stallCycleA += 4;
			stallCycleB += 4;
			break;
		}
	}

	if (!hit) {
		for (int i = 0; i < 8; i++) {
			if (cache[index].validAndTagAndLRU[i].lru == 0) {
				cache[index].validAndTagAndLRU[i].v = true;  // miss
				cache[index].validAndTagAndLRU[i].tag = tag;
				cache[index].validAndTagAndLRU[i].lru = 7;
				for (int j = 0; j < 8; j++)
					if (j != i && cache[index].validAndTagAndLRU[j].lru > 0)
						--cache[index].validAndTagAndLRU[j].lru;
				stallCycleA += 1 + 8 * (1 + 100 + 1 + 2) + 2 + 1;
				stallCycleB += 1 + (1 + 100 + 1 + 2) + 2 + 1;
				break;
			}
		}
	}

	return;
}

void getDataC(cache_content_eight_way* cacheL1, cache_content_eight_way* cacheL2, const unsigned int& indexL1, const unsigned int& tagL1, const unsigned int& indexL2, const unsigned int& tagL2, int& stallCycle) {
	bool hitL1 = false, hitL2 = false;

	// L1 cache hit
	for (int i = 0; i < 8; i++) {
		if (cacheL1[indexL1].validAndTagAndLRU[i].v && cacheL1[indexL1].validAndTagAndLRU[i].tag == tagL1) {
			cacheL1[indexL1].validAndTagAndLRU[i].v = true;  // L1 hit
			int lastLRU = cacheL1[indexL1].validAndTagAndLRU[i].lru;
			cacheL1[indexL1].validAndTagAndLRU[i].lru = 7;
			for (int j = 0; j < 8; j++)
				if (j != i && cacheL1[indexL1].validAndTagAndLRU[j].lru > lastLRU)
					--cacheL1[indexL1].validAndTagAndLRU[j].lru;
			hitL1 = true;
			break;
		}
	}

	if (!hitL1) {
		// L2 cache hit
		for (int i = 0; i < 8; i++) {
			if (cacheL2[indexL2].validAndTagAndLRU[i].v && cacheL2[indexL2].validAndTagAndLRU[i].tag == tagL2) {
				cacheL2[indexL2].validAndTagAndLRU[i].v = true;  // L2 hit
				int lastLRU = cacheL2[indexL2].validAndTagAndLRU[i].lru;
				cacheL2[indexL2].validAndTagAndLRU[i].lru = 7;
				for (int j = 0; j < 8; j++)
					if (j != i && cacheL2[indexL2].validAndTagAndLRU[j].lru > lastLRU)
						--cacheL2[indexL2].validAndTagAndLRU[j].lru;
				hitL2 = true;
				break;
			}
		}
		// L2 cache miss
		if (!hitL2) {
			for (int i = 0; i < 8; i++) {
				if (cacheL2[indexL2].validAndTagAndLRU[i].lru == 0) {
					cacheL2[indexL2].validAndTagAndLRU[i].v = true;  // L2 miss
					cacheL2[indexL2].validAndTagAndLRU[i].tag = tagL2;
					cacheL2[indexL2].validAndTagAndLRU[i].lru = 7;
					for (int j = 0; j < 8; j++)
						if (j != i && cacheL2[indexL2].validAndTagAndLRU[j].lru > 0)
							--cacheL2[indexL2].validAndTagAndLRU[j].lru;
					break;
				}
			}
		}

		// L1 cache miss
		for (int i = 0; i < 8; i++) {
			if (cacheL1[indexL1].validAndTagAndLRU[i].lru == 0) {
				cacheL1[indexL1].validAndTagAndLRU[i].v = true;  // L1 miss
				cacheL1[indexL1].validAndTagAndLRU[i].tag = tagL1;
				cacheL1[indexL1].validAndTagAndLRU[i].lru = 7;
				for (int j = 0; j < 8; j++)
					if (j != i && cacheL1[indexL1].validAndTagAndLRU[j].lru > 0)
						--cacheL1[indexL1].validAndTagAndLRU[j].lru;
				break;
			}
		}
	}


	if (hitL1)
		stallCycle += 1 + 1 + 1;
	else if (hitL2)
		stallCycle += 1 + 4 * (1 + 10 + 1 + 1) + 1 + 1;
	else
		stallCycle += 1 + 32 * (1 + 100 + 1 + 10) + 4 * (1 + 10 + 1 + 1) + 1 + 1;

	return;
}
