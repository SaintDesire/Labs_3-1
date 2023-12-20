#include <iostream>
#include <Windows.h>

int main()
{
	int pid = GetCurrentProcessId();
	HANDLE semaphore = OpenSemaphore(SEMAPHORE_ALL_ACCESS, FALSE, L"OS06_04");

	for (int i = 1; i <= 90; i++)
	{
		if (i == 30)
			WaitForSingleObject(semaphore, INFINITE);

		else if (i == 60)
			ReleaseSemaphore(semaphore, 1, NULL);


		printf("[OS06_04B]\t%d.  PID = %d\n", i, pid);
		Sleep(100);
	}
	system("pause");

	CloseHandle(semaphore);
}