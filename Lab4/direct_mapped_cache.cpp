#include <iostream>
#include <stdio.h>
#include <cmath>

using namespace std;

struct cache_content
{
	bool v;
	unsigned int tag;
	// unsigned int	data[16];
};

const int K = 1024;

double log2(double n)
{
	// log(n) / log(2) is log2.
	return log(n) / log(double(2));
}


void simulate(int cache_size, int block_size, int type)
{
	unsigned int tag, index, x;

	int offset_bit = (int)log2(block_size);
	int index_bit = (int)log2(cache_size / block_size);
	int line = cache_size >> (offset_bit);

	cache_content *cache = new cache_content[line];

	cout << "offset_bit: " << offset_bit << endl
		<< "index_bit: " << index_bit << endl
		<< "cache line: " << line << endl;

	for (int j = 0; j < line; j++)
		cache[j].v = false;

	FILE *fp = (type == 0) ? fopen("ICACHE.txt", "r") : fopen("DCACHE.txt", "r");  // read file

	int access = 0, miss = 0;
	while (fscanf(fp, "%x", &x) != EOF)
	{
		//cout << hex << x << " ";
		index = (x >> offset_bit) & (line - 1);
		tag = x >> (index_bit + offset_bit);
		if (cache[index].v && cache[index].tag == tag)
			cache[index].v = true;  // hit
		else {
			cache[index].v = true;  // miss
			cache[index].tag = tag;
			++miss;
		}
		++access;
	}
	fclose(fp);
	cout << "Miss Rate: " << dec << (double)miss / access << endl << endl;

	delete[] cache;
}

int main()
{
	// Let us simulate 4KB cache with 16B blocks
	for (int i = 0; i < 2; i++) {
		if (i == 0) cout << "//////////////////////////" << endl
			<< "//Start ICACHE////////////" << endl;
		else cout << "//////////////////////////" << endl
			<< "//Start DCACHE////////////" << endl;
		for (int j = 32; j > 3; j /= 2)
			for (int k = 4; k < 33; k *= 2) {
				cout << K / j << "B cache" << endl
					<< k << "B blocks" << endl;
				simulate(K / j, k, i);
			}
		if (i == 0) cout << "//End ICACHE//////////////" << endl
			<< "//////////////////////////" << endl << endl;
		else cout << "//End DCACHE//////////////" << endl
			<< "//////////////////////////" << endl << endl;
	}
}
