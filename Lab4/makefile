output: direct_mapped_cache.o 
	g++ direct_mapped_cache.o -o output

direct_mapped_cache.o: direct_mapped_cache.cpp
	g++ -c direct_mapped_cache.cpp

output2: direct_mapped_cache_lru.o
	g++ direct_mapped_cache_lru.o -o output2
	
direct_mapped_cache_lru.o: direct_mapped_cache_lru.cpp
	g++ -c direct_mapped_cache_lru.cpp

	
clean:
	rm *.o output output2