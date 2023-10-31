#include <iostream>
#include <thread>
#include <mutex>

using namespace std;

mutex mtx;

void threadA() {
    for (int i = 0; i < 90; i++) {
        mtx.lock();
        cout << "Thread A: " << i << endl;
        mtx.unlock();
        this_thread::sleep_for(chrono::milliseconds(100));
    }
}

void threadB() {
    for (int i = 0; i < 90; i++) {
        mtx.lock();
        cout << "Thread B: " << i << endl;
        mtx.unlock();
        this_thread::sleep_for(chrono::milliseconds(100));
    }
}

int main() {
    thread tA(threadA);
    thread tB(threadB);

    for (int i = 0; i < 90; i++) {
        mtx.lock();
        cout << "Main Thread: " << i << endl;
        mtx.unlock();
        this_thread::sleep_for(chrono::milliseconds(100));
    }

    tA.join();
    tB.join();

    return 0;
}