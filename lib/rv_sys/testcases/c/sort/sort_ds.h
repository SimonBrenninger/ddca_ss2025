#define DATA_SIZE 10

int input_data[DATA_SIZE] =
{
  1, 1073741823, 0, -1, -1073741824,
  2, 3, 4, -3, -2
};

int verify_data[DATA_SIZE] =
{
  -1073741824, -3, -2, -1, 0,
  1, 2, 3, 4, 1073741823
};
