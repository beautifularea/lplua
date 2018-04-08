std::string str;
char * writable = new char[str.size() + 1];
std::copy(str.begin(), str.end(), writable);
writable[str.size()] = '\0'; // don't forget the terminating 0

// don't forget to free the string after finished using it
delete[] writable;
