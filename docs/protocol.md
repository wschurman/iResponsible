UDP:

Request Format:
    32 bits
    Want: [0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30]
    Have: [1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 27, 29, 31]

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
