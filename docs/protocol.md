UDP:
    Request Format:
        64 bits

          front of request                                                                                                  back of request
          least significant bit                                                                                             most significant bit
        Want: [0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32, 34, 36, 38, 40, 42, 44, 46, 48, 50, 52, 54, 56, 58, 60, 62]
        Have: [1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 27, 29, 31, 33, 35, 37, 39, 41, 43, 45, 47, 49, 51, 53, 55, 57, 59, 61, 63]

    Response Format
        8 bits:
        Either:
            [0, 0, 0, 0, 0, 0, 0, 1]
            [0, 0, 0, 0, 0, 0, 1, 0]
            [0, 0, 0, 0, 0, 1, 0, 0]
            [0, 0, 0, 0, 1, 0, 0, 0]
            [0, 0, 0, 1, 0, 0, 0, 0]
            [0, 0, 1, 0, 0, 0, 0, 0]
            [0, 1, 0, 0, 0, 0, 0, 0]
            [1, 0, 0, 0, 0, 0, 0, 0]
            for yes, you can afford this

        or

            Any 3 bits (not necessarily in a row) are 1
            for no, you can't afford that
