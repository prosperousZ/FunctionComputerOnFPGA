package assembler;

/**
 * This is the assembler class
 * @author prime: Haoze Zhang		second: Yuntong Lu
 *
 */

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.Scanner;

import assembler.Instruction.ID;

public class Main {

	public static void main(String[] args) {
		readTextFileUsingScanner(args[0]);
		try {
			bufferedWritter(finalResult, args[1]);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	public static String a2b(String asciiString){

          byte[] bytes = asciiString.getBytes();
          StringBuilder binary = new StringBuilder();
					boolean other = false;
          for (byte b : bytes)
          {
             int val = b;
						 binary.append("00000000");
             for (int i = 0; i < 8; i++)
             {
                binary.append((val & 128) == 0 ? 0 : 1);
                val <<= 1;
             }

						 binary.append("\n");
            // binary.append(' ');
          }
					//null termination
					binary.append("0000000000000000\n");
          return binary.toString();
    }

	public static Instruction.ID insID = Instruction.ID.ADDI;
	public static String instructionID = "";
	public static String rsM = "";
	public static String rdM = "";
	public static int immediateM = 0;
	public static int jumpAddressM = 0;
	public static String label = "";
	public static Instruction ins = null;
	private static String finalResult = "";
  public static int lineno;
	// every thing works except @
	public static void readTextFileUsingScanner(String filename) {
    lineno = 0;
		try {
			// For check displacement
			int indexM = 0;
			File file = new File(filename);
			Scanner sc = new Scanner(file);
			label l = new label();
			l.checkLabel(filename);
			// get the address for each label
			while (sc.hasNextLine()) {
        lineno++;
				String str = sc.nextLine();
				String orig = str.trim();
				str = str.replaceAll("\\s", "");
				// deal with the white space
				if (str.length() == 0) {
					continue;
				}
				// Common situation
				if (str.contains("#")) {
					continue;
				}

				if (str.contains("@")) {
					continue;
				}
				if (str.substring(0, 1).equals(".")) {
					if (str.contains("\"")){
						String literal = orig.substring(orig.indexOf("\"")+1,orig.length()-1);
						finalResult += a2b(literal);
						indexM += literal.length()+1;
					}
					continue;
				}

				if (str.contains("$")) {
					throw new NullPointerException("please write register without $");
				}
				indexM++;
				// string to char array
				char[] STCA = str.toCharArray();
				int index = 0;
				// decide if this is hex number
				boolean isHex = false;
				// decide if there is negative number
				if (str.contains("-")) {
					// negative
					index = 4;
				} else {
					// positive
					index = 3;
				}
				if (str.contains("0x")) {
					isHex = true;
				}
				//To count how many , in string
				int nu = 0;
				for(int j = 0; j < str.length(); j ++) {
					if(str.substring(j, j+1).equals(",")) {
						nu++;
					}
				}
				// Read from string, this includes immidiate number
				// Deal with the situation when instruction ID has 3 characters
				if ((STCA[0] != 'O') && (STCA[0] != 'B')
						&& ((STCA[index] == '1') && (!str.contains("."))|| (STCA[index] == '2') || (STCA[index] == '3') || (STCA[index] == '4')
								|| (STCA[index] == '5') || (STCA[index] == '6') || (STCA[index] == '7')
								|| (STCA[index] == '8') || (STCA[index] == '9') || (STCA[index] == '0'))) {

					instructionID = Character.toString(STCA[0]) + Character.toString(STCA[1])
							+ Character.toString(STCA[2]);
					insID = ID.valueOf(instructionID);
					immediateM = Character.getNumericValue(STCA[index]);
					rdM = "";
					// if the number is 2 digits
					if ((STCA[index + 1] == '1') || (STCA[index + 1] == '2') || (STCA[index + 1] == '3')
							|| (STCA[index + 1] == '4') || (STCA[index + 1] == '5') || (STCA[index + 1] == '6')
							|| (STCA[index + 1] == '7') || (STCA[index + 1] == '8') || (STCA[index + 1] == '9')
							|| (STCA[index + 1] == '0')) {
						// deal with 3 digit
						if ((STCA[index + 2] == '1') || (STCA[index + 2] == '2') || (STCA[index + 2] == '3')
								|| (STCA[index + 2] == '4') || (STCA[index + 2] == '5') || (STCA[index + 2] == '6')
								|| (STCA[index + 2] == '7') || (STCA[index + 2] == '8') || (STCA[index + 2] == '9')
								|| (STCA[index + 2] == '0')) {
							immediateM = Character.getNumericValue(STCA[index]) * 100
									+ Character.getNumericValue(STCA[index + 1]) * 10
									+ Character.getNumericValue(STCA[index + 2]);
							for (int i = index + 4; i < STCA.length; i++) {
								rdM = rdM + Character.toString(STCA[i]);
							}
							if (isHex == true) {
								immediateM = Integer.parseInt(Character.toString(STCA[5]), 16) * 16
										+ Integer.parseInt(Character.toString(STCA[6]), 16);
								rdM = "";
								for (int i = 8; i < STCA.length; i++) {
									rdM = rdM + Character.toString(STCA[i]);
								}
							}
							ins = new Instruction(insID, rdM, immediateM);
							negOrPos(index);
							ins.change();
							finalResult = finalResult + ins.result;
							// Break one iteration
							System.out.println(indexM+" "+instructionID);
							continue;
						}
						immediateM = Character.getNumericValue(STCA[index]) * 10
								+ Character.getNumericValue(STCA[index + 1]);
						for (int i = index + 3; i < STCA.length; i++) {
							rdM = rdM + Character.toString(STCA[i]);
						}
						if (isHex == true) {
							immediateM = Integer.parseInt(Character.toString(STCA[5]), 16) * 16
									+ Integer.parseInt(Character.toString(STCA[6]), 16);
							rdM = "";
							for (int i = 8; i < STCA.length; i++) {
								rdM = rdM + Character.toString(STCA[i]);
							}
						}
						ins = new Instruction(insID, rdM, immediateM);
						negOrPos(index);
						ins.change();
						finalResult = finalResult + ins.result;
						// Break one iteration
						System.out.println(indexM+" "+instructionID);
						continue;
					}
					for (int i = index + 2; i < STCA.length; i++) {
						rdM = rdM + Character.toString(STCA[i]);
					}
					if (isHex == true) {
						immediateM = Integer.parseInt(Character.toString(STCA[5]), 16) * 16
								+ Integer.parseInt(Character.toString(STCA[6]), 16);
						rdM = "";
						for (int i = 8; i < STCA.length; i++) {
							rdM = rdM + Character.toString(STCA[i]);
						}
					}
					ins = new Instruction(insID, rdM, immediateM);
					negOrPos(index);
					ins.change();
					finalResult = finalResult + ins.result;
					// when instruction ID has 4 characters with numbers
				} else if ((STCA[0] != 'O') && (STCA[1] != 'S') && (STCA[3] != 'r') && (STCA[0] != 'B')
						&& (!str.contains("."))&&((STCA[index + 1] == '1') || (STCA[index + 1] == '2') || (STCA[index + 1] == '3')
								|| (STCA[index + 1] == '4') || (STCA[index + 1] == '5') || (STCA[index + 1] == '6')
								|| (STCA[index + 1] == '7') || (STCA[index + 1] == '8') || (STCA[index + 1] == '9')
								|| (STCA[index + 1] == '0'))) {

					instructionID = Character.toString(STCA[0]) + Character.toString(STCA[1])
							+ Character.toString(STCA[2]) + Character.toString(STCA[3]);
					rdM = "";
					insID = ID.valueOf(instructionID);
					immediateM = Character.getNumericValue(STCA[index + 1]);
					// deal with the number is 2 digits
					if ((STCA[index + 2] == '1') || (STCA[index + 2] == '2') || (STCA[index + 2] == '3')
							|| (STCA[index + 2] == '4') || (STCA[index + 2] == '5') || (STCA[index + 2] == '6')
							|| (STCA[index + 2] == '7') || (STCA[index + 2] == '8') || (STCA[index + 2] == '9')
							|| (STCA[index + 2] == '0')) {

						// Deal with 3 digit number
						if ((STCA[index + 3] == '1') || (STCA[index + 3] == '2') || (STCA[index + 3] == '3')
								|| (STCA[index + 3] == '4') || (STCA[index + 3] == '5') || (STCA[index + 3] == '6')
								|| (STCA[index + 3] == '7') || (STCA[index + 3] == '8') || (STCA[index + 3] == '9')
								|| (STCA[index + 3] == '0')) {
							immediateM = Character.getNumericValue(STCA[index + 1]) * 100
									+ Character.getNumericValue(STCA[index + 2]) * 10
									+ Character.getNumericValue(STCA[index + 3]);
							for (int i = index + 5; i < STCA.length; i++) {
								rdM = rdM + Character.toString(STCA[i]);

							}
							if (isHex == true) {
								immediateM = Integer.parseInt(Character.toString(STCA[6]), 16) * 16
										+ Integer.parseInt(Character.toString(STCA[7]), 16);
								rdM = "";
								for (int i = 9; i < STCA.length; i++) {
									rdM = rdM + Character.toString(STCA[i]);
								}
							}
							ins = new Instruction(insID, rdM, immediateM);
							negOrPos(index);
							ins.change();
							finalResult = finalResult + ins.result;
							System.out.println(indexM+" "+instructionID);
							continue;
						}
						immediateM = Character.getNumericValue(STCA[index + 1]) * 10
								+ Character.getNumericValue(STCA[index + 2]);
						for (int i = index + 4; i < STCA.length; i++) {
							rdM = rdM + Character.toString(STCA[i]);

						}
						if (isHex == true) {
							immediateM = Integer.parseInt(Character.toString(STCA[6]), 16) * 16
									+ Integer.parseInt(Character.toString(STCA[7]), 16);
							rdM = "";
							for (int i = 9; i < STCA.length; i++) {
								rdM = rdM + Character.toString(STCA[i]);
							}
						}
						ins = new Instruction(insID, rdM, immediateM);
						negOrPos(index);
						ins.change();
						finalResult = finalResult + ins.result;
						System.out.println(indexM+" "+instructionID);
						continue;
					}
					for (int i = index + 3; i < STCA.length; i++) {
						rdM = rdM + Character.toString(STCA[i]);
					}
					if (isHex == true) {
						immediateM = Integer.parseInt(Character.toString(STCA[6]), 16) * 16
								+ Integer.parseInt(Character.toString(STCA[7]), 16);
						rdM = "";
						for (int i = 9; i < STCA.length; i++) {
							rdM = rdM + Character.toString(STCA[i]);
						}
					}
					ins = new Instruction(insID, rdM, immediateM);
					negOrPos(index);
					ins.change();
					finalResult = finalResult + ins.result;

					// deal with the situation that has no immediate number
				} else if (((STCA[3] == 'r') || (STCA[3] == 's')) && (STCA[0] != 'J') && (STCA[0] != 'B')&& (!str.contains("."))) {

					instructionID = Character.toString(STCA[0]) + Character.toString(STCA[1])
							+ Character.toString(STCA[2]);
					insID = ID.valueOf(instructionID);
					rdM = "";
					rsM = "";
					int in = 3;
					while (STCA[in] != ',') {
						rsM = rsM + Character.toString(STCA[in]);
						in++;
					}
					for (int i = in + 1; i < STCA.length; i++) {
						rdM = rdM + Character.toString(STCA[i]);
					}
					ins = new Instruction(insID, rsM, rdM);
					ins.change();
					finalResult = finalResult + ins.result;
				} else if ((STCA[2] == 'r') || (STCA[2] == 's')) {
					instructionID = Character.toString(STCA[0]) + Character.toString(STCA[1]);
					insID = ID.valueOf(instructionID);
					rdM = "";
					rsM = "";
					int in = 2;
					while (STCA[in] != ',') {
						rsM = rsM + Character.toString(STCA[in]);
						in++;
					}
					for (int i = in + 1; i < STCA.length; i++) {
						rdM = rdM + Character.toString(STCA[i]);
					}
					ins = new Instruction(insID, rsM, rdM);
					ins.change();
					finalResult = finalResult + ins.result;

					// Special condition load and stor
				} else if (((STCA[4] == 'r') || (STCA[4] == 's')) && (STCA[0] != 'J') && (STCA[0] != 'B') && (!str.contains("("))) {
					//System.out.print("here");
					instructionID = Character.toString(STCA[0]) + Character.toString(STCA[1])
							+ Character.toString(STCA[2]) + Character.toString(STCA[3]);

					insID = ID.valueOf(instructionID);
					rdM = "";
					rsM = "";
					int in = 4;
					while (STCA[in] != ',') {
						rsM = rsM + Character.toString(STCA[in]);
						in++;
					}
					for (int i = in + 1; i < STCA.length; i++) {
						rdM = rdM + Character.toString(STCA[i]);
					}
					ins = new Instruction(insID, rsM, rdM);
					ins.change();
					finalResult = finalResult + ins.result;

					//load with label
				}else if(((STCA[4] == 'r') || (STCA[4] == 's')) && (STCA[0] != 'J') && (STCA[0] != 'B') && (str.contains("(")) && (nu < 2)) {
						instructionID = "MOVI";
						insID = ID.valueOf(instructionID);
						rdM = "";
						int in = 4;
						//Label string
						String ss = "";
						//represent number
						String tem = "";
						//represent label followed by register
						String rsM2 = "";
						while (STCA[in] != ',') {
							rdM = rdM + Character.toString(STCA[in]);
							in++;
						}
						in = in+2;
						while(STCA[in] != '(') {
							//get the label here
							ss += STCA[in] + "";
							in++;
						}

						immediateM = Integer.parseInt(l.label.get(ss), 16);
						tem = Integer.toBinaryString(immediateM);
						if (tem.length() == 1) {
							tem = "000000000000000" + tem;
						} else if (tem.length() == 2) {
							tem = "00000000000000" + tem;
						} else if (tem.length() == 3) {
							tem = "0000000000000" + tem;
						} else if (tem.length() == 4) {
							tem = "000000000000" + tem;
						} else if (tem.length() == 5) {
							tem = "00000000000" + tem;
						} else if (tem.length() == 6) {
							tem = "0000000000" + tem;
						} else if (tem.length() == 7) {
							tem = "000000000" + tem;
						} else if (tem.length() == 8) {
							tem = "00000000" + tem;
						} else if (tem.length() == 9) {
							tem = "0000000" + tem;
						} else if (tem.length() == 10) {
							tem = "000000" + tem;
						} else if (tem.length() == 11) {
							tem = "00000" + tem;
						} else if (tem.length() == 12) {
							tem = "0000" + tem;
						} else if (tem.length() == 13) {
							tem = "000" + tem;
						} else if (tem.length() == 14) {
							tem = "00" + tem;
						} else if (tem.length() == 15) {
							tem = "0" + tem;
						}
						immediateM = Integer.parseInt(tem.substring(8, 16), 2);
						ins = new Instruction(insID, "r13", immediateM);
						ins.change();
						finalResult = finalResult + ins.result;
						finalResult = finalResult + "11111101" + tem.substring(0, 8) + "\n";
						indexM = indexM + 1;
						in = in+2;
						while(STCA[in] != ')') {
							//get the number here
							rsM2 += STCA[in] + "";
							in ++;
						}
						rsM2 = Integer.toBinaryString(Integer.parseInt(rsM2));
						if (rsM2.length() == 1) {
							rsM2 = "000" + rsM2;
						} else if (rsM2.length() == 2) {
							rsM2 = "00" + rsM2;

						} else if (rsM2.length() == 3) {
							rsM2 =  "0" + rsM2;
						}
						finalResult = finalResult + "000011010101" + rsM2 + "\n";
						indexM = indexM + 1;
						ins = new Instruction(insID = ID.valueOf("LOAD"), rdM, "r13");
						ins.change();
						finalResult = finalResult + ins.result;
						indexM = indexM + 1;
						//deal with another situation load with label with number
				}else if(((STCA[4] == 'r') || (STCA[4] == 's')) && (STCA[0] != 'J') && (STCA[0] != 'B') && (str.contains("(")) && (nu == 2)) {
					instructionID = "MOVI";
					insID = ID.valueOf(instructionID);
					rdM = "";
					int in = 4;
					//Label string
					String ss = "";
					//represent number
					String tem = "";
					//represent label followed by register
					String rsM2 = "";
					String number = "";
					int num = 0;
					while (STCA[in] != ',') {
						rdM = rdM + Character.toString(STCA[in]);
						in++;
					}
					in = in+2;
					while(STCA[in] != '(') {
						//get the label here
						ss += STCA[in] + "";
						in++;
					}

					immediateM = Integer.parseInt(l.label.get(ss), 16);
					tem = Integer.toBinaryString(immediateM);
					if (tem.length() == 1) {
						tem = "000000000000000" + tem;
					} else if (tem.length() == 2) {
						tem = "00000000000000" + tem;
					} else if (tem.length() == 3) {
						tem = "0000000000000" + tem;
					} else if (tem.length() == 4) {
						tem = "000000000000" + tem;
					} else if (tem.length() == 5) {
						tem = "00000000000" + tem;
					} else if (tem.length() == 6) {
						tem = "0000000000" + tem;
					} else if (tem.length() == 7) {
						tem = "000000000" + tem;
					} else if (tem.length() == 8) {
						tem = "00000000" + tem;
					} else if (tem.length() == 9) {
						tem = "0000000" + tem;
					} else if (tem.length() == 10) {
						tem = "000000" + tem;
					} else if (tem.length() == 11) {
						tem = "00000" + tem;
					} else if (tem.length() == 12) {
						tem = "0000" + tem;
					} else if (tem.length() == 13) {
						tem = "000" + tem;
					} else if (tem.length() == 14) {
						tem = "00" + tem;
					} else if (tem.length() == 15) {
						tem = "0" + tem;
					}
					immediateM = Integer.parseInt(tem.substring(8, 16), 2);
					ins = new Instruction(insID, "r13", immediateM);
					ins.change();
					finalResult = finalResult + ins.result;
					finalResult = finalResult + "11111101" + tem.substring(0, 8) + "\n";
					indexM = indexM + 1;
					in = in+2;

					while(STCA[in] != ',') {
						//get the number here
						rsM2 += STCA[in] + "";
						in ++;
					}
					rsM2 = Integer.toBinaryString(Integer.parseInt(rsM2));
					if (rsM2.length() == 1) {
						rsM2 = "000" + rsM2;
					} else if (rsM2.length() == 2) {
						rsM2 = "00" + rsM2;

					} else if (rsM2.length() == 3) {
						rsM2 =  "0" + rsM2;
					}
					finalResult = finalResult + "000011010101" + rsM2 + "\n";
					indexM = indexM + 1;
					in = in+ 1;
					if(index == 4) {
						in = in + 1;
					}
					while(STCA[in] != ')') {
						number += STCA[in] + "";
						in++;
					}
					num = Integer.parseInt(number);
					if(index == 4) {
						num = -num;
					}
					number = Integer.toBinaryString(num);
					if(index == 3) {
						if (number.length() == 1) {
							number = "0000000" + number;
						} else if (number.length() == 2) {
							number = "000000" + number;
						} else if (number.length() == 3) {
						   number = "00000" + number;
						} else if (number .length() == 4) {
							number = "0000" + number;
						} else if (number.length() == 5) {
							number = "000" + number;
						} else if (number.length() == 6) {
							number = "00" + number;
						} else if (number.length() == 7) {
							number= "0" + number;
						}
					}
					else {
						number = number.substring(24, 32);
					}
					finalResult = finalResult + "01011101" + number + "\n";
					indexM = indexM +1;
					ins = new Instruction(insID = ID.valueOf("LOAD"), rdM, "r13");
					ins.change();
					finalResult = finalResult + ins.result;
					indexM = indexM + 1;

			}else if((STCA[0] == 'M') && (STCA[1] == 'O') && (STCA[2] == 'V') && (STCA[3] != 'I') && (str.contains(".")) && (nu < 2)) {
				instructionID = "MOVI";
				insID = ID.valueOf(instructionID);
				rdM = "";
				int in = 4;
				//Label string
				String ss = "";
				//represent number
				String tem = "";
				//represent label followed by register
				String rsM2 = "";
				while(STCA[in] != '(') {
					//get the label here
					ss += STCA[in] + "";
					in++;
				}
				in = in+2;
				while (STCA[in] != ')') {
					rsM2 = rsM2 + Character.toString(STCA[in]);
					in++;
				}
				System.out.println("Moving address from label " + ss +" at hex address " + l.label.get(ss));
				immediateM = Integer.parseInt(l.label.get(ss), 16);
				tem = Integer.toBinaryString(immediateM);
				if (tem.length() == 1) {
					tem = "000000000000000" + tem;
				} else if (tem.length() == 2) {
					tem = "00000000000000" + tem;
				} else if (tem.length() == 3) {
					tem = "0000000000000" + tem;
				} else if (tem.length() == 4) {
					tem = "000000000000" + tem;
				} else if (tem.length() == 5) {
					tem = "00000000000" + tem;
				} else if (tem.length() == 6) {
					tem = "0000000000" + tem;
				} else if (tem.length() == 7) {
					tem = "000000000" + tem;
				} else if (tem.length() == 8) {
					tem = "00000000" + tem;
				} else if (tem.length() == 9) {
					tem = "0000000" + tem;
				} else if (tem.length() == 10) {
					tem = "000000" + tem;
				} else if (tem.length() == 11) {
					tem = "00000" + tem;
				} else if (tem.length() == 12) {
					tem = "0000" + tem;
				} else if (tem.length() == 13) {
					tem = "000" + tem;
				} else if (tem.length() == 14) {
					tem = "00" + tem;
				} else if (tem.length() == 15) {
					tem = "0" + tem;
				}
				immediateM = Integer.parseInt(tem.substring(8, 16), 2);
				ins = new Instruction(insID, "r13", immediateM);
				ins.change();
				System.out.println(indexM+"\t"+insID);
				finalResult = finalResult + ins.result;
				indexM = indexM + 1;
				System.out.println(indexM+"\tLUI ");
				finalResult = finalResult + "11111101" + tem.substring(0, 8) + "\n";

				in = in+2;
				while(in != STCA.length) {
					//get the number here
					rdM += STCA[in] + "";
					in ++;
				}
				rsM2 = Integer.toBinaryString(Integer.parseInt(rsM2));
				if (rsM2.length() == 1) {
					rsM2 = "000" + rsM2;
				} else if (rsM2.length() == 2) {
					rsM2 = "00" + rsM2;

				} else if (rsM2.length() == 3) {
					rsM2 =  "0" + rsM2;
				}

				indexM = indexM + 1;
				System.out.println(indexM+"\tADDI");
				finalResult = finalResult + "000011010101" + rsM2 + "\n";

				ins = new Instruction(insID = ID.valueOf("MOV"), "r13", rdM);
				ins.change();
				finalResult = finalResult + ins.result;
				indexM = indexM + 1;
		}
			else if((STCA[0] == 'M') && (STCA[1] == 'O') && (STCA[2] == 'V') && (STCA[3] != 'I') && (str.contains(".")) && (nu == 2)) {
				instructionID = "MOVI";
				insID = ID.valueOf(instructionID);
				rdM = "";
				int in = 4;
				//Label string
				String ss = "";
				//represent number
				String tem = "";
				//represent label followed by register
				String rsM2 = "";
				int num = 0;
				String number = "";
				while(STCA[in] != '(') {
					//get the label here
					ss += STCA[in] + "";
					in++;
				}
				in = in+2;
				while (STCA[in] != ',') {
					rsM2 = rsM2 + Character.toString(STCA[in]);
					in++;
				}
				in = in+1;
				if(index == 4) {
					in = in + 1;
				}
				while(STCA[in] != ')') {
					number += STCA[in] + "";
					in++;
				}
				num = Integer.parseInt(number);
				if(index == 4) {
					num = -num;
				}
				number = Integer.toBinaryString(num);
				if(index == 3) {
					if (number.length() == 1) {
						number = "0000000" + number;
					} else if (number.length() == 2) {
						number = "000000" + number;
					} else if (number.length() == 3) {
					   number = "00000" + number;
					} else if (number .length() == 4) {
						number = "0000" + number;
					} else if (number.length() == 5) {
						number = "000" + number;
					} else if (number.length() == 6) {
						number = "00" + number;
					} else if (number.length() == 7) {
						number= "0" + number;
					}
				}
				else {
					number = number.substring(24, 32);
				}
				immediateM = Integer.parseInt(l.label.get(ss), 16);
				tem = Integer.toBinaryString(immediateM);
				if (tem.length() == 1) {
					tem = "000000000000000" + tem;
				} else if (tem.length() == 2) {
					tem = "00000000000000" + tem;
				} else if (tem.length() == 3) {
					tem = "0000000000000" + tem;
				} else if (tem.length() == 4) {
					tem = "000000000000" + tem;
				} else if (tem.length() == 5) {
					tem = "00000000000" + tem;
				} else if (tem.length() == 6) {
					tem = "0000000000" + tem;
				} else if (tem.length() == 7) {
					tem = "000000000" + tem;
				} else if (tem.length() == 8) {
					tem = "00000000" + tem;
				} else if (tem.length() == 9) {
					tem = "0000000" + tem;
				} else if (tem.length() == 10) {
					tem = "000000" + tem;
				} else if (tem.length() == 11) {
					tem = "00000" + tem;
				} else if (tem.length() == 12) {
					tem = "0000" + tem;
				} else if (tem.length() == 13) {
					tem = "000" + tem;
				} else if (tem.length() == 14) {
					tem = "00" + tem;
				} else if (tem.length() == 15) {
					tem = "0" + tem;
				}
				immediateM = Integer.parseInt(tem.substring(8, 16), 2);
				ins = new Instruction(insID, "r13", immediateM);
				ins.change();
				finalResult = finalResult + ins.result;
				finalResult = finalResult + "11111101" + tem.substring(0, 8) + "\n";
				indexM = indexM + 1;
				in = in+2;
				while(in != STCA.length) {
					//get the number here
					rdM += STCA[in] + "";
					in ++;
				}
				rsM2 = Integer.toBinaryString(Integer.parseInt(rsM2));
				if (rsM2.length() == 1) {
					rsM2 = "000" + rsM2;
				} else if (rsM2.length() == 2) {
					rsM2 = "00" + rsM2;

				} else if (rsM2.length() == 3) {
					rsM2 =  "0" + rsM2;
				}
				finalResult = finalResult + "000011010101" + rsM2 + "\n";
				indexM = indexM + 1;
				finalResult = finalResult + "01011101" + number + "\n";
				indexM = indexM +1;
				ins = new Instruction(insID = ID.valueOf("MOV"), "r13", rdM);
				ins.change();
				finalResult = finalResult + ins.result;
				indexM = indexM + 1;
		}
			else if((STCA[0] == 'M') && (STCA[1] == 'O') && (STCA[2] == 'V') && (STCA[3] == 'I') && (str.contains("."))) {
				instructionID = "MOVI";
				insID = ID.valueOf(instructionID);
				int in = 4;
				if(index == 4) {
					in = in+1;
				}
				//Label string
				String ss = "";
				//represent number
				String tem = "";
				String number = "";
				int num = 0;
				while(STCA[in] != ',') {
					//get the number here
					number += STCA[in] + "";
					in++;
				}
				in = in+3;
				while (STCA[in] != ')') {
					ss= ss + Character.toString(STCA[in]);
					in++;
				}
				immediateM = Integer.parseInt(l.label.get(ss), 16);
				tem = Integer.toBinaryString(immediateM);
				if (tem.length() == 1) {
					tem = "000000000000000" + tem;
				} else if (tem.length() == 2) {
					tem = "00000000000000" + tem;
				} else if (tem.length() == 3) {
					tem = "0000000000000" + tem;
				} else if (tem.length() == 4) {
					tem = "000000000000" + tem;
				} else if (tem.length() == 5) {
					tem = "00000000000" + tem;
				} else if (tem.length() == 6) {
					tem = "0000000000" + tem;
				} else if (tem.length() == 7) {
					tem = "000000000" + tem;
				} else if (tem.length() == 8) {
					tem = "00000000" + tem;
				} else if (tem.length() == 9) {
					tem = "0000000" + tem;
				} else if (tem.length() == 10) {
					tem = "000000" + tem;
				} else if (tem.length() == 11) {
					tem = "00000" + tem;
				} else if (tem.length() == 12) {
					tem = "0000" + tem;
				} else if (tem.length() == 13) {
					tem = "000" + tem;
				} else if (tem.length() == 14) {
					tem = "00" + tem;
				} else if (tem.length() == 15) {
					tem = "0" + tem;
				}
				immediateM = Integer.parseInt(tem.substring(8, 16), 2);
				ins = new Instruction(insID, "r13", immediateM);
				ins.change();
				finalResult = finalResult + ins.result;
				finalResult = finalResult + "11111101" + tem.substring(0, 8) + "\n";
				indexM = indexM + 1;

				//Decide if is negative number
				num = Integer.parseInt(number);
				if(index == 4) {
					num = -num;
				}
				number = Integer.toBinaryString(num);
				if(index == 3) {
					if (number.length() == 1) {
						number = "0000000" + number;
					} else if (number.length() == 2) {
						number = "000000" + number;
					} else if (number.length() == 3) {
					   number = "00000" + number;
					} else if (number .length() == 4) {
						number = "0000" + number;
					} else if (number.length() == 5) {
						number = "000" + number;
					} else if (number.length() == 6) {
						number = "00" + number;
					} else if (number.length() == 7) {
						number= "0" + number;
					}
				}
				else {
					number = number.substring(24, 32);
				}
				finalResult = finalResult + "01011110" + number + "\n";
				indexM = indexM + 1;
				ins = new Instruction(insID = ID.valueOf("STOR"), "r14", "r13");
				ins.change();
				finalResult = finalResult + ins.result;
				indexM = indexM + 1;
		}
			// ORI instruction
				else if ((STCA[0] == 'O') && (STCA[1] == 'R') && (STCA[2] == 'I')&& (!str.contains("."))) {

					instructionID = Character.toString(STCA[0]) + Character.toString(STCA[1])
							+ Character.toString(STCA[2]);
					insID = ID.valueOf(instructionID);
					rdM = "";
					immediateM = Character.getNumericValue(STCA[index]);
					if ((STCA[index + 1] == '1') || (STCA[index + 1] == '2') || (STCA[index + 1] == '3')
							|| (STCA[index + 1] == '4') || (STCA[index + 1] == '5') || (STCA[index + 1] == '6')
							|| (STCA[index + 1] == '7') || (STCA[index + 1] == '8') || (STCA[index + 1] == '9')
							|| (STCA[index + 1] == '0')) {

						// Deal with 3 digit number
						if ((STCA[index + 2] == '1') || (STCA[index + 2] == '2') || (STCA[index + 2] == '3')
								|| (STCA[index + 2] == '4') || (STCA[index + 2] == '5') || (STCA[index + 2] == '6')
								|| (STCA[index + 2] == '7') || (STCA[index + 2] == '8') || (STCA[index + 2] == '9')
								|| (STCA[index + 2] == '0')) {
							immediateM = Character.getNumericValue(STCA[index]) * 100
									+ Character.getNumericValue(STCA[index + 1]) * 10
									+ Character.getNumericValue(STCA[index + 2]);
							for (int i = index + 4; i < STCA.length; i++) {
								rdM = rdM + Character.toString(STCA[i]);

							}
							if (isHex == true) {
								immediateM = Integer.parseInt(Character.toString(STCA[5]), 16) * 16
										+ Integer.parseInt(Character.toString(STCA[6]), 16);
								rdM = "";
								for (int i = 8; i < STCA.length; i++) {
									rdM = rdM + Character.toString(STCA[i]);
								}
							}
							ins = new Instruction(insID, rdM, immediateM);
							negOrPos(index);
							ins.change();
							finalResult = finalResult + ins.result;

							System.out.println(indexM+" "+instructionID);
							continue;
						}
						immediateM = Character.getNumericValue(STCA[index]) * 10
								+ Character.getNumericValue(STCA[index + 1]);
						for (int i = index + 3; i < STCA.length; i++) {
							rdM = rdM + Character.toString(STCA[i]);
						}
						if (isHex == true) {
							immediateM = Integer.parseInt(Character.toString(STCA[5]), 16) * 16
									+ Integer.parseInt(Character.toString(STCA[6]), 16);
							rdM = "";
							for (int i = 8; i < STCA.length; i++) {
								rdM = rdM + Character.toString(STCA[i]);
							}
						}
						ins = new Instruction(insID, rdM, immediateM);
						negOrPos(index);
						ins.change();
						finalResult = finalResult + ins.result;
						System.out.println(indexM+" "+instructionID);

						continue;
					}
					for (int i = index + 2; i < STCA.length; i++) {
						rdM = rdM + Character.toString(STCA[i]);
					}
					if (isHex == true) {
						immediateM = Integer.parseInt(Character.toString(STCA[5]), 16) * 16
								+ Integer.parseInt(Character.toString(STCA[6]), 16);
						rdM = "";
						for (int i = 8; i < STCA.length; i++) {
							rdM = rdM + Character.toString(STCA[i]);
						}
					}
					ins = new Instruction(insID, rdM, immediateM);
					negOrPos(index);
					ins.change();
					finalResult = finalResult + ins.result;

					// deal with Jcond, still without label
				} else if ((STCA[0] == 'J')
						&& ((STCA[1] == 'E') || (STCA[1] == 'N') || (STCA[1] == 'C') || (STCA[1] == 'H')
								|| (STCA[1] == 'L') || (STCA[1] == 'G') || (STCA[1] == 'F') || (STCA[1] == 'U'))
						&& STCA[3] == 'r') {
					instructionID = Character.toString(STCA[0]) + Character.toString(STCA[1])
							+ Character.toString(STCA[2]);
					insID = ID.valueOf(instructionID);
					// clear rdM was stored last time
					rdM = "";
					for (int i = 3; i < STCA.length; i++) {
						rdM = rdM + Character.toString(STCA[i]);
					}
					ins = new Instruction(insID, rdM);
					ins.change();
					finalResult = finalResult + ins.result;
					System.out.println("Jump with "+ins.result);
				}
				// The situation is Jcond .label
				else if ((STCA[0] == 'J')
						&& ((STCA[1] == 'E') || (STCA[1] == 'N') || (STCA[1] == 'C') || (STCA[1] == 'H')
								|| (STCA[1] == 'L') || (STCA[1] == 'G') || (STCA[1] == 'F') || (STCA[1] == 'U'))
						&& STCA[3] == '.') {
					// Use for get memory address
					String tem = "";
					String temCode = "";
					rdM = "r13";
					String ss = "";
					instructionID = "MOVI";
					for (int i = 4; i < STCA.length; i++) {
						ss = ss + STCA[i];
					}
					insID = ID.valueOf(instructionID);
					System.out.println("Found jump "+ss+" at hex addr "+l.label.get(ss));
					// Get the address of label
					immediateM = Integer.parseInt(l.label.get(ss), 16);
					tem = Integer.toBinaryString(immediateM);
					if (tem.length() == 1) {
						tem = "000000000000000" + tem;
					} else if (tem.length() == 2) {
						tem = "00000000000000" + tem;
					} else if (tem.length() == 3) {
						tem = "0000000000000" + tem;
					} else if (tem.length() == 4) {
						tem = "000000000000" + tem;
					} else if (tem.length() == 5) {
						tem = "00000000000" + tem;
					} else if (tem.length() == 6) {
						tem = "0000000000" + tem;
					} else if (tem.length() == 7) {
						tem = "000000000" + tem;
					} else if (tem.length() == 8) {
						tem = "00000000" + tem;
					} else if (tem.length() == 9) {
						tem = "0000000" + tem;
					} else if (tem.length() == 10) {
						tem = "000000" + tem;
					} else if (tem.length() == 11) {
						tem = "00000" + tem;
					} else if (tem.length() == 12) {
						tem = "0000" + tem;
					} else if (tem.length() == 13) {
						tem = "000" + tem;
					} else if (tem.length() == 14) {
						tem = "00" + tem;
					} else if (tem.length() == 15) {
						tem = "0" + tem;
					}
					immediateM = Integer.parseInt(tem.substring(8, 16), 2);
					// System.out.print(immediateM);
					ins = new Instruction(insID, rdM, immediateM);
					ins.change();
					finalResult = finalResult + ins.result;
					finalResult = finalResult + "11111101" + tem.substring(0, 8) + "\n";
					indexM = indexM + 1;
					if (STCA[1] == 'E' && STCA[2] == 'Q') {
						temCode = "0000";
					} else if (STCA[1] == 'N' && STCA[2] == 'E') {
						temCode = "0001";
					} else if (STCA[1] == 'C' && STCA[2] == 'S') {
						temCode = "0010";
					} else if (STCA[1] == 'C' && STCA[2] == 'C') {
						temCode = "0011";
					} else if (STCA[1] == 'H' && STCA[2] == 'I') {
						temCode = "0100";
					} else if (STCA[1] == 'L' && STCA[2] == 'S') {
						temCode = "0101";
					} else if (STCA[1] == 'G' && STCA[2] == 'T') {
						temCode = "0110";
					} else if (STCA[1] == 'L' && STCA[2] == 'E') {
						temCode = "0111";
					} else if (STCA[1] == 'F' && STCA[2] == 'S') {
						temCode = "1000";
					} else if (STCA[1] == 'F' && STCA[2] == 'C') {
						temCode = "1001";
					} else if (STCA[1] == 'L' && STCA[2] == 'O') {
						temCode = "1010";
					} else if (STCA[1] == 'H' && STCA[2] == 'S') {
						temCode = "1011";
					} else if (STCA[1] == 'L' && STCA[2] == 'T') {
						temCode = "1100";
					} else if (STCA[1] == 'G' && STCA[2] == 'E') {
						temCode = "1101";
					} else if (STCA[1] == 'U' && STCA[2] == 'C') {
						temCode = "1110";
					}
					// J to address
					finalResult = finalResult + "0100" + temCode + "11001101" + "\n";
					indexM = indexM + 1;
				}
				// Fix that s bug, the number is this instruction should be <= 15
				else if ((STCA[0] == 'L') && (STCA[1] == 'S') && (STCA[2] == 'H') && (!str.contains("."))&&(STCA[3] == 'I')) {
					instructionID = Character.toString(STCA[0]) + Character.toString(STCA[1])
							+ Character.toString(STCA[2]) + Character.toString(STCA[3]);
					insID = ID.valueOf(instructionID);
					rdM = "";
					immediateM = Character.getNumericValue(STCA[index + 1]);
					if ((STCA[index + 2] == '1') || (STCA[index + 2] == '2') || (STCA[index + 2] == '3')
							|| (STCA[index + 2] == '4') || (STCA[index + 2] == '5') || (STCA[index + 2] == '6')
							|| (STCA[index + 2] == '7') || (STCA[index + 2] == '8') || (STCA[index + 2] == '9')
							|| (STCA[index + 2] == '0')) {
						immediateM = Character.getNumericValue(STCA[index + 1]) * 10
								+ Character.getNumericValue(STCA[index + 2]);
						// Number exception
						if (immediateM > 15) {
							throw new NullPointerException("LSHI instruction can only take number less equal to 15");
						}
						for (int i = index + 4; i < STCA.length; i++) {
							rdM = rdM + Character.toString(STCA[i]);
						}
						if (isHex == true) {
							immediateM = Integer.parseInt(Character.toString(STCA[6]), 16) * 16
									+ Integer.parseInt(Character.toString(STCA[7]), 16);
							rdM = "";
							for (int i = 9; i < STCA.length; i++) {
								rdM = rdM + Character.toString(STCA[i]);
							}
						}
						ins = new Instruction(insID, rdM, immediateM);
						negOrPos(index);
						ins.change();
						finalResult = finalResult + ins.result;
						System.out.println(indexM+" "+instructionID);
						continue;
					}
					for (int i = index + 3; i < STCA.length; i++) {
						rdM = rdM + Character.toString(STCA[i]);
					}
					if (isHex == true) {
						immediateM = Integer.parseInt(Character.toString(STCA[6]), 16) * 16
								+ Integer.parseInt(Character.toString(STCA[7]), 16);
						rdM = "";
						for (int i = 9; i < STCA.length; i++) {
							rdM = rdM + Character.toString(STCA[i]);
						}
					}
					ins = new Instruction(insID, rdM, immediateM);
					negOrPos(index);
					ins.change();
					finalResult = finalResult + ins.result;
				} else if ((STCA[0] == 'J') && (STCA[1] == 'A') && (STCA[2] == 'L')) {
					instructionID = Character.toString(STCA[0]) + Character.toString(STCA[1])
							+ Character.toString(STCA[2]);
					insID = ID.valueOf(instructionID);
					rdM = "";
					rsM = "";
					int in = 3;
					while (STCA[in] != ',') {
						rsM = rsM + Character.toString(STCA[in]);
						in++;
					}
					String ss = "";
					for (int i = in+2; i < STCA.length; i++) {
						ss = ss + STCA[i];
					}
					int addr = Integer.parseInt(l.label.get(ss),16);
					ins = new Instruction(ID.valueOf("MOVI"), "r13", addr);
					ins.change();
					System.out.print("JAL: "+ins.result);
					finalResult = finalResult + ins.result;
					indexM++;
					System.out.println("JAL to: " +addr);
					finalResult = finalResult + "11111101" + String.format("%16s", Integer.toBinaryString(addr)).replace(' ', '0').substring(0,8)+"\n";
					indexM++;

					ins = new Instruction(insID, rsM, "r13");
					ins.change();
					System.out.println("JAL INS: "+ins.result);
					finalResult = finalResult + ins.result+"\n";
					// deal with Bcond with number
				} else if ((STCA[0] == 'B') && (STCA[3] != '.')) {
					instructionID = Character.toString(STCA[0]) + Character.toString(STCA[1])
							+ Character.toString(STCA[2]);
					insID = ID.valueOf(instructionID);
					immediateM = Character.getNumericValue(STCA[index]);
					// if the number is 2 digits
					if ((STCA.length == index + 2) && ((STCA[index + 1] == '1') || (STCA[index + 1] == '2')
							|| (STCA[index + 1] == '3') || (STCA[index + 1] == '4') || (STCA[index + 1] == '5')
							|| (STCA[index + 1] == '6') || (STCA[index + 1] == '7') || (STCA[index + 1] == '8')
							|| (STCA[index + 1] == '9') || (STCA[index + 1] == '0'))) {
						// deal with 3 digit
						if ((STCA.length == index + 3) && ((STCA[index + 2] == '1') || (STCA[index + 2] == '2')
								|| (STCA[index + 2] == '3') || (STCA[index + 2] == '4') || (STCA[index + 2] == '5')
								|| (STCA[index + 2] == '6') || (STCA[index + 2] == '7') || (STCA[index + 2] == '8')
								|| (STCA[index + 2] == '9') || (STCA[index + 2] == '0'))) {
							immediateM = Character.getNumericValue(STCA[index]) * 100
									+ Character.getNumericValue(STCA[index + 1]) * 10
									+ Character.getNumericValue(STCA[index + 2]);
							if (isHex == true) {
								immediateM = Integer.parseInt(Character.toString(STCA[5]), 16) * 16
										+ Integer.parseInt(Character.toString(STCA[6]), 16);
							}
							ins = new Instruction(insID, immediateM);
							ins.isNumber = true;
							negOrPos(index);
							ins.change();
							finalResult = finalResult + ins.result;
							System.out.println(indexM+" "+instructionID);
							continue;
						}
						immediateM = Character.getNumericValue(STCA[index]) * 10
								+ Character.getNumericValue(STCA[index + 1]);
						if (isHex == true) {
							immediateM = Integer.parseInt(Character.toString(STCA[5]), 16) * 16
									+ Integer.parseInt(Character.toString(STCA[6]), 16);
						}
						ins = new Instruction(insID, immediateM);
						ins.isNumber = true;
						negOrPos(index);
						ins.change();
						finalResult = finalResult + ins.result;
						System.out.println(indexM+" "+instructionID);
						continue;
					}
					if (isHex == true) {
						immediateM = Integer.parseInt(Character.toString(STCA[5]), 16) * 16
								+ Integer.parseInt(Character.toString(STCA[6]), 16);
					}
					ins = new Instruction(insID, immediateM);
					ins.isNumber = true;
					negOrPos(index);
					ins.change();
					finalResult = finalResult + ins.result;
				}
				// Deal with Bcond label condition
				else if ((STCA[0] == 'B')
						&& ((STCA[1] == 'E') || (STCA[1] == 'N') || (STCA[1] == 'C') || (STCA[1] == 'H')
								|| (STCA[1] == 'L') || (STCA[1] == 'G') || (STCA[1] == 'F') || (STCA[1] == 'U'))
						&& (STCA[3] == '.')) {
					String ss = "";
					instructionID = Character.toString(STCA[0]) + Character.toString(STCA[1])
							+ Character.toString(STCA[2]);
					for (int i = 4; i < STCA.length; i++) {
						ss = ss + STCA[i];
					}
					insID = ID.valueOf(instructionID);
					// Get the address of label
					immediateM = Integer.parseInt(l.label.get(ss), 16) - indexM;
					System.out.println("Branch at "+indexM+" to "+ss+" at "+Integer.parseInt(l.label.get(ss), 16) + " with offset "+(Integer.parseInt(l.label.get(ss), 16) - indexM));
					ins = new Instruction(insID, immediateM);
					ins.change();
					finalResult = finalResult + ins.result;
				}
				System.out.println(indexM+" "+insID);
			}
			//System.out.print(indexM);
			sc.close();
		} catch (Exception e) {
      System.out.println("Error on line " + lineno);
			e.printStackTrace();
		}
	}

	/**
	 * File reader method
	 *
	 * @param s
	 * @throws IOException
	 */
	public static void bufferedWritter(String s, String filename) throws IOException {
		BufferedWriter writer = new BufferedWriter(new FileWriter(
				filename));
		writer.write(s);
		writer.close();
	}

	/**
	 * decide positive number of negative number, only 3 or 4
	 *
	 * @param i
	 */
	public static void negOrPos(int i) {
		if (i == 3) {
			ins.neg = false;
		} else {
			ins.neg = true;
		}
	}
}
