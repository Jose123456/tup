#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include "dir_mutex.h"

int readlinkat(int dirfd, const char *pathname, char *buf, size_t bufsiz)
{
	int rc;
	int cwd;

	pthread_mutex_lock(&dir_mutex);

	cwd = open(".", O_RDONLY);
	if(fchdir(dirfd) < 0) {
		perror("fchdir");
		goto err_close;
	}
	rc = readlink(pathname, buf, bufsiz);
	if(fchdir(cwd) < 0) {
		perror("fchdir");
		goto err_close;
	}
	close(cwd);
	pthread_mutex_unlock(&dir_mutex);
	return rc;

err_close:
	close(cwd);
	pthread_mutex_unlock(&dir_mutex);
	return -1;
}
