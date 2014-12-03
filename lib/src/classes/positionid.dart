/**
 * Gnu position id:
 *
 * concat a '1' for each piece the specified player has on each point
 * concat a '0' for every point. The bar is counted as point 25
 * concat a '0'
 * then, working in the opposite direction:
 * concat a '1' for each piece the other player has on each point
 * concat a '0' for every point. The bar is counted as point 25
 * pad to length of 80 with '0'
 * convert to little endian - reverse each set of 8 'bits'
 * concat 4 more '0'
 * convert to 14 bytes, each a 6 bit base64 value
 *
 * at the start of every game, the board looks like this:
 * 4HPwATDgc/ABMA
 *
 */
const String RADIX64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
