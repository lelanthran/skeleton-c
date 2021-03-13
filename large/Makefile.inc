debug/skeleton-3.14.59/obs/x86_64-linux-gnu/proj-one/cpp_module.o: proj-one/cpp_module.cpp
	$(CXX) $(CXXFLAGS) -c -o $@ $<
debug/skeleton-3.14.59/obs/x86_64-linux-gnu/proj-one/c_module.o: proj-one/c_module.c
	$(CC) $(CFLAGS) -c -o $@ $<
debug/skeleton-3.14.59/obs/x86_64-linux-gnu/proj-one/source/newmod.o: proj-one/source/newmod.c
	$(CC) $(CFLAGS) -c -o $@ $<
debug/skeleton-3.14.59/obs/x86_64-linux-gnu/proj-one/c_main.o: proj-one/c_main.c
	$(CC) $(CFLAGS) -c -o $@ $<
debug/skeleton-3.14.59/obs/x86_64-linux-gnu/proj-one/cpp_main.o: proj-one/cpp_main.cpp
	$(CXX) $(CXXFLAGS) -c -o $@ $<
debug/skeleton-3.14.59/lib/x86_64-linux-gnu/libproj-one-3.14.59.so: debug/skeleton-3.14.59/obs/x86_64-linux-gnu/proj-one/cpp_module.o debug/skeleton-3.14.59/obs/x86_64-linux-gnu/proj-one/c_module.o debug/skeleton-3.14.59/obs/x86_64-linux-gnu/proj-one/source/newmod.o debug/skeleton-3.14.59/obs/x86_64-linux-gnu/proj-one/c_main.o debug/skeleton-3.14.59/obs/x86_64-linux-gnu/proj-one/cpp_main.o
debug/skeleton-3.14.59/obs/x86_64-linux-gnu/proj-two/cpp_module.o: proj-two/cpp_module.cpp
	$(CXX) $(CXXFLAGS) -c -o $@ $<
debug/skeleton-3.14.59/obs/x86_64-linux-gnu/proj-two/c_module.o: proj-two/c_module.c
	$(CC) $(CFLAGS) -c -o $@ $<
debug/skeleton-3.14.59/obs/x86_64-linux-gnu/proj-two/c_main.o: proj-two/c_main.c
	$(CC) $(CFLAGS) -c -o $@ $<
debug/skeleton-3.14.59/obs/x86_64-linux-gnu/proj-two/cpp_main.o: proj-two/cpp_main.cpp
	$(CXX) $(CXXFLAGS) -c -o $@ $<
debug/skeleton-3.14.59/lib/x86_64-linux-gnu/libproj-two-3.14.59.so: debug/skeleton-3.14.59/obs/x86_64-linux-gnu/proj-two/cpp_module.o debug/skeleton-3.14.59/obs/x86_64-linux-gnu/proj-two/c_module.o debug/skeleton-3.14.59/obs/x86_64-linux-gnu/proj-two/c_main.o debug/skeleton-3.14.59/obs/x86_64-linux-gnu/proj-two/cpp_main.o
debug/skeleton-3.14.59/obs/x86_64-linux-gnu/proj-three/cpp_module.o: proj-three/cpp_module.cpp
	$(CXX) $(CXXFLAGS) -c -o $@ $<
debug/skeleton-3.14.59/obs/x86_64-linux-gnu/proj-three/c_module.o: proj-three/c_module.c
	$(CC) $(CFLAGS) -c -o $@ $<
debug/skeleton-3.14.59/obs/x86_64-linux-gnu/proj-three/c_main.o: proj-three/c_main.c
	$(CC) $(CFLAGS) -c -o $@ $<
debug/skeleton-3.14.59/obs/x86_64-linux-gnu/proj-three/cpp_main.o: proj-three/cpp_main.cpp
	$(CXX) $(CXXFLAGS) -c -o $@ $<
debug/skeleton-3.14.59/lib/x86_64-linux-gnu/libproj-three-3.14.59.so: debug/skeleton-3.14.59/obs/x86_64-linux-gnu/proj-three/cpp_module.o debug/skeleton-3.14.59/obs/x86_64-linux-gnu/proj-three/c_module.o debug/skeleton-3.14.59/obs/x86_64-linux-gnu/proj-three/c_main.o debug/skeleton-3.14.59/obs/x86_64-linux-gnu/proj-three/cpp_main.o
