#include <iostream>
#include <stdio.h>
#include <cmath>

using namespace std;

struct valid_tag_lru
{
	bool v;
	unsigned int tag;
	unsigned int lru;
};

struct cache_content_one_way
{
	bool v;
	unsigned int tag;
};

struct cache_content_two_way
{
	valid_tag_lru validAndTagAndLRU[2];
};

struct cache_content_four_way
{
	valid_tag_lru validAndTagAndLRU[4];
};

struct cache_content_eight_way
{
	valid_tag_lru validAndTagAndLRU[8];
};

const int K = 1024;

double log2(double n)
{
	// log(n) / log(2) is log2.
	return log(n) / log(double(2));
}


void simulate(int cacheSize, int blockSize, int type)
{
	unsigned int tagOneWay, tagTwoWay, tagFourWay, tagEightWay;
	unsigned int indexOneWay, indexTwoWay, indexFourWay, indexEightWay;
	unsigned int x;

	int offsetBit = (int)log2(blockSize);
	int indexBitOneWay = (int)log2(cacheSize / blockSize);
	int indexBitTwoWay = (int)indexBitOneWay - 1;
	int indexBitFourWay = (int)indexBitTwoWay - 1;
	int indexBitEightWay = (int)indexBitFourWay - 1;
	int setOneWay = cacheSize >> (offsetBit);
	int setTwoWay = setOneWay / 2;
	int setFourWay = setTwoWay / 2;
	int setEightWay = setFourWay / 2;

	cache_content_one_way *cacheOneWay = new cache_content_one_way[setOneWay];
	cache_content_two_way *cacheTwoWay = new cache_content_two_way[setTwoWay];
	cache_content_four_way *cacheFourWay = new cache_content_four_way[setFourWay];
	cache_content_eight_way *cacheEightWay = new cache_content_eight_way[setEightWay];

	cout << "offsetBit: " << offsetBit << endl
		<< "indexBitOneWay: " << indexBitOneWay << endl
		<< "indexBitTwoWay: " << indexBitTwoWay << endl
		<< "indexBitFourWay: " << indexBitFourWay << endl
		<< "indexBitEightWay: " << indexBitEightWay << endl
		<< "cache line (1-way): " << setOneWay << endl
		<< "cache line (2-way): " << setTwoWay << endl
		<< "cache line (4-way): " << setFourWay << endl
		<< "cache line (8-way): " << setEightWay << endl;

	for (int j = 0; j < setOneWay; j++)
		cacheOneWay->v = false;
	for (int j = 0; j < setTwoWay; j++)
		for (int k = 0; k < 2; k++) {
			cacheTwoWay[j].validAndTagAndLRU[k].v = false;
			cacheTwoWay[j].validAndTagAndLRU[k].lru = k;
		}
	for (int j = 0; j < setFourWay; j++)
		for (int k = 0; k < 4; k++) {
			cacheFourWay[j].validAndTagAndLRU[k].v = false;
			cacheFourWay[j].validAndTagAndLRU[k].lru = k;
		}
	for (int j = 0; j < setEightWay; j++)
		for (int k = 0; k < 8; k++) {
			cacheEightWay[j].validAndTagAndLRU[k].v = false;
			cacheEightWay[j].validAndTagAndLRU[k].lru = k;
		}

	FILE *fp = (type == 0) ? fopen("LU.txt", "r") : fopen("RADIX.txt", "r");  // read file

	unsigned int access = 0;
	unsigned int missOneWay = 0, missTwoWay = 0,
		missFourWay = 0, missEightWay = 0;
	while (fscanf(fp, "%x", &x) != EOF)
	{
		//cout << hex << x << " ";
		indexOneWay = (x >> offsetBit) & (setOneWay - 1);
		indexTwoWay = (x >> offsetBit) & (setTwoWay - 1);
		indexFourWay = (x >> offsetBit) & (setFourWay - 1);
		indexEightWay = (x >> offsetBit) & (setEightWay - 1);
		tagOneWay = x >> (indexBitOneWay + offsetBit);
		tagTwoWay = x >> (indexBitTwoWay + offsetBit);
		tagFourWay = x >> (indexBitFourWay + offsetBit);
		tagEightWay = x >> (indexBitEightWay + offsetBit);



		//One Way
		if (cacheOneWay[indexOneWay].v && cacheOneWay[indexOneWay].tag == tagOneWay) {
			cacheOneWay[indexOneWay].v = true;  // hit
		}
		else {
			cacheOneWay[indexOneWay].v = true;  // miss
			cacheOneWay[indexOneWay].tag = tagOneWay;
			++missOneWay;
		}



		//Two Way
		if (cacheTwoWay[indexTwoWay].validAndTagAndLRU[0].v && cacheTwoWay[indexTwoWay].validAndTagAndLRU[0].tag == tagTwoWay) {
			cacheTwoWay[indexTwoWay].validAndTagAndLRU[0].v = true;  // hit
			cacheTwoWay[indexTwoWay].validAndTagAndLRU[0].lru = 1;
			cacheTwoWay[indexTwoWay].validAndTagAndLRU[1].lru = 0;
		}
		else if (cacheTwoWay[indexTwoWay].validAndTagAndLRU[1].v && cacheTwoWay[indexTwoWay].validAndTagAndLRU[1].tag == tagTwoWay) {
			cacheTwoWay[indexTwoWay].validAndTagAndLRU[1].v = true;  // hit
			cacheTwoWay[indexTwoWay].validAndTagAndLRU[0].lru = 0;
			cacheTwoWay[indexTwoWay].validAndTagAndLRU[1].lru = 1;
		}
		else if (cacheTwoWay[indexTwoWay].validAndTagAndLRU[0].lru == 0) {
			cacheTwoWay[indexTwoWay].validAndTagAndLRU[0].v = true;  // miss
			cacheTwoWay[indexTwoWay].validAndTagAndLRU[0].tag = tagTwoWay;
			cacheTwoWay[indexTwoWay].validAndTagAndLRU[0].lru = 1;
			cacheTwoWay[indexTwoWay].validAndTagAndLRU[1].lru = 0;
			++missTwoWay;
		}
		else if (cacheTwoWay[indexTwoWay].validAndTagAndLRU[1].lru == 0) {
			cacheTwoWay[indexTwoWay].validAndTagAndLRU[1].v = true;  // miss
			cacheTwoWay[indexTwoWay].validAndTagAndLRU[1].tag = tagTwoWay;
			cacheTwoWay[indexTwoWay].validAndTagAndLRU[0].lru = 0;
			cacheTwoWay[indexTwoWay].validAndTagAndLRU[1].lru = 1;
			++missTwoWay;
		}



		//Four Way
		bool hit = false;
		for (int j = 0; j < 4; j++) {
			if (cacheFourWay[indexFourWay].validAndTagAndLRU[j].v && cacheFourWay[indexFourWay].validAndTagAndLRU[j].tag == tagFourWay) {
				cacheFourWay[indexFourWay].validAndTagAndLRU[j].v = true;  // hit
				int lastLRU = cacheFourWay[indexFourWay].validAndTagAndLRU[j].lru;
				cacheFourWay[indexFourWay].validAndTagAndLRU[j].lru = 3;
				for (int k = 0; k < 4; k++)
					if (k != j && cacheFourWay[indexFourWay].validAndTagAndLRU[k].lru > lastLRU)
						--cacheFourWay[indexFourWay].validAndTagAndLRU[k].lru;
				hit = true;
				break;
			}
		}
		if (!hit) {
			for (int j = 0; j < 4; j++) {
				if (cacheFourWay[indexFourWay].validAndTagAndLRU[j].lru == 0) {
					cacheFourWay[indexFourWay].validAndTagAndLRU[j].v = true;  // miss
					cacheFourWay[indexFourWay].validAndTagAndLRU[j].tag = tagFourWay;
					cacheFourWay[indexFourWay].validAndTagAndLRU[j].lru = 3;
					for (int k = 0; k < 4; k++)
						if (k != j)
							--cacheFourWay[indexFourWay].validAndTagAndLRU[k].lru;
					break;
				}
			}
			++missFourWay;
		}



		//Eight Way
		hit = false;
		for (int j = 0; j < 8; j++) {
			if (cacheEightWay[indexEightWay].validAndTagAndLRU[j].v && cacheEightWay[indexEightWay].validAndTagAndLRU[j].tag == tagEightWay) {
				cacheEightWay[indexEightWay].validAndTagAndLRU[j].v = true;  // hit
				int lastLRU = cacheEightWay[indexEightWay].validAndTagAndLRU[j].lru;
				cacheEightWay[indexEightWay].validAndTagAndLRU[j].lru = 7;
				for (int k = 0; k < 8; k++)
					if (k != j && cacheEightWay[indexEightWay].validAndTagAndLRU[k].lru > lastLRU)
						--cacheEightWay[indexEightWay].validAndTagAndLRU[k].lru;
				hit = true;
				break;
			}
		}
		if (!hit) {
			for (int j = 0; j < 8; j++) {
				if (cacheEightWay[indexEightWay].validAndTagAndLRU[j].lru == 0) {
					cacheEightWay[indexEightWay].validAndTagAndLRU[j].v = true;  // miss
					cacheEightWay[indexEightWay].validAndTagAndLRU[j].tag = tagEightWay;
					cacheEightWay[indexEightWay].validAndTagAndLRU[j].lru = 7;
					for (int k = 0; k < 8; k++)
						if (k != j && cacheEightWay[indexEightWay].validAndTagAndLRU[k].lru > 0)
							--cacheEightWay[indexEightWay].validAndTagAndLRU[k].lru;
					break;
				}
			}
			++missEightWay;
		}

		++access;
	}
	fclose(fp);
	cout << "Miss Rate (1-way): " << dec << (double)missOneWay / access << endl
		<< "Miss Rate (2-way): " << dec << (double)missTwoWay / access << endl
		<< "Miss Rate (4-way): " << dec << (double)missFourWay / access << endl
		<< "Miss Rate (8-way): " << dec << (double)missEightWay / access << endl << endl;

	delete[] cacheOneWay;
	delete[] cacheTwoWay;
	delete[] cacheFourWay;
	delete[] cacheEightWay;
}

int main()
{
	// Let us simulate 4KB cache with 16B blocks
	for (int i = 0; i < 2; i++) {
		if (i == 0) cout << "///////////////////////////////" << endl
			<< "//Start LU/////////////////////" << endl;
		else cout << "///////////////////////////////" << endl
			<< "//Start RADIX//////////////////" << endl;
		for (int j = 1; j < 33; j *= 2) {
			cout << j << "KB cache" << endl
				<< "64B blocks" << endl;
			simulate(j * K, 64, i);
		}
		if (i == 0) cout << "///////////////////////////////" << endl
			<< "//End LU///////////////////////" << endl << endl;
		else cout << "///////////////////////////////" << endl
			<< "//End RADIX////////////////////" << endl << endl;
	}
}

