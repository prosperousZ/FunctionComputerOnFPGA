package assembler;

public class Instruction {

	/**
	 * All instructions
	 *
	 * @author prime: Haoze Zhang		second: Yuntong Lu
	 *
	 */
	public enum ID {
		ADD, ADDI, SUB, SUBI, CMP, CMPI, AND, ANDI, OR, ORI, XOR, XORI, MOV, MOVI, LSH, LSHI, LUI, LOAD, STOR,
		//Bcond
		BEQ,
		BNE,
		BCS,
		BCC,
		BHI,
		BLS,
		BGT,
		BLE,
		BFS,
		BFC,
		BLO,
		BHS,
		BLT,
		BGE,
		BUC,
		//Jcond
		JEQ,
		JNE,
		JCS,
		JCC,
		JHI,
		JLS,
		JGT,
		JLE,
		JFS,
		JFC,
		JLO,
		JHS,
		JLT,
		JGE,
		JUC,
		//end here
		JAL,
		// Link and include are all added for extra use
		//Link, Include,
		// new instruction id
		LDSD, // load from SD card
		STSD, // store into SD card

	};

	public final ID instruction_id;
	public final String rs;
	public final String rd;
	public int immediate;
	public final int jumpAddress;
	public final String label;
	public String result = "";
	//negative number
	public boolean neg= false;
	//Case if the Bcond is with number
	public boolean isNumber = false;


	/**
	 * All type of instructions, structures
	 *
	 * @param instruction_id
	 * @param rd
	 * @param rs
	 * @param immediate
	 * @param jumpAddress
	 * @param shiftAmount
	 * @param label
	 * @param branchLabel
	 */

	// Default constructor
	public Instruction(String input) {
		this(ID.ADDI, "","",0,0,"");
	}

	/**
	 * Keep doing instructions, but need to set up different type
	 */

	protected Instruction(ID instruction_id, String rs, String rd, int immediate, int jumpAddress, String label) {
		this.instruction_id = instruction_id;
		this.rs = rs;
		this.rd = rd;
		this.immediate = immediate;
		this.jumpAddress = jumpAddress;
		this.label = label;
	}

	// Used for calculated and shift
	protected Instruction(ID instruction_id, String rs, String rd) {
		this(instruction_id, rs, rd, 0, 0, "");
	}

	// Can be used for load and store
	protected Instruction(ID instruction_id, String rd, int immediate) {
		this(instruction_id, "", rd, immediate, 0, "");
	}

	// B-Type
	protected Instruction(ID instruction_id, int jump_address) {
		this(instruction_id, "", "", jump_address, 0, "");
	}

	// branch label instead of jump address or target register
	protected Instruction(ID instruction_id, String label) {
		this(instruction_id, "", label, 0, 0, label);
	}

	/**
	 * Use for register
	 */

	public String useForReg(String s) {
			if (s.length() == 1) {
				return "000" + s;
			} else if (s.length() == 2) {
				return "00" + s;

			} else if (s.length() == 3) {
				return "0" + s;
			}
		return s;
	}

	/**
	 * Different type of extend binary
	 * @param s
	 * @return
	 */
	public String extendBinary(String s) {
		if(neg == false) {
			if (s.length() == 1) {
				return "000" + s;
			} else if (s.length() == 2) {
				return "00" + s;

			} else if (s.length() == 3) {
				return "0" + s;
			}
			}

		else
		{
			return s.substring(28, 32);
		}
		return s;
	}

	/**
	 * use for immediate
	 */

	public String extendBinary2(String s) {
		if(neg == false) {
			if(s.length()>8){
				s = s.substring(s.length()-8,s.length());
			}
			if (s.length() == 1) {
				return "0000000" + s;
			} else if (s.length() == 2) {
				return "000000" + s;
			} else if (s.length() == 3) {
				return "00000" + s;
			} else if (s.length() == 4) {
				return "0000" + s;
			} else if (s.length() == 5) {
				return "000" + s;
			} else if (s.length() == 6) {
				return "00" + s;
			} else if (s.length() == 7) {
				return "0" + s;
			}
		}
		else {
			return s.substring(24, 32);
		}
		return s;
	}

	@Override
	public String toString() {
		return "Instruction{" + "instruction_id=" + instruction_id.toString() + ", rd=" + rd + ", rs=" + rs
				+ ", immediate=" + immediate + ", jump_address=" + jumpAddress + ", label=" + label + "\n" + '}';
	}

	/**
	 * convert
	 *
	 * @param st
	 * @return
	 */
	public String registerConverter(String st) {
		char register[] = st.toCharArray();
		if(register.length == 3) {
			return useForReg(Integer.toBinaryString(Character.getNumericValue(register[1])*10 + Character.getNumericValue(register[2])));
		}
		return useForReg(Integer.toBinaryString(Character.getNumericValue(register[1])));
	}

	/**
	 * check for sign
	 */
	public int checkSign(int i) {
		if(i < 0){
			return 1;
		}
		return 0;
	}

	/**
	 * Write binary code into file
	 */
	public void change() {
		switch (instruction_id) {
		// Doing each operation here
		case ADD:
			result = "0000" + registerConverter(this.rd) + "0101" + registerConverter(this.rs) + "\n";
			break;
		case ADDI:
			if(neg == true) {
				immediate = -immediate;
			}
			result = "0101"  + registerConverter(this.rd) + extendBinary2(Integer.toBinaryString(immediate)) + "\n";
			break;
		case SUB:
			result = "0000" + registerConverter(this.rd) + "1001" + registerConverter(this.rs) + "\n";
			break;
		case SUBI:
			if(neg == true) {
				immediate = -immediate;
			}
			result = "1001" + registerConverter(this.rd) + extendBinary2(Integer.toBinaryString(immediate)) + "\n";
			break;
		case CMP:
			result = "0000" + registerConverter(this.rd) + "1011" + registerConverter(this.rs)+ "\n";
			break;
		case CMPI:
			if(neg == true) {
				immediate = -immediate;
			}
			result = "1011" + registerConverter(this.rd) + extendBinary2(Integer.toBinaryString(immediate)) + "\n";
			break;
		case AND:
			result = "0000" + registerConverter(this.rd) + "0001" + registerConverter(this.rs) + "\n";
			break;
		case ANDI:
			if(neg == true) {
				immediate = -immediate;
			}
			result = "0001" + registerConverter(this.rd) + extendBinary2(Integer.toBinaryString(immediate)) + '\n';
			break;
		case OR:
			result = "0000" + registerConverter(this.rd) + "0010" + registerConverter(this.rs) +"\n";
			break;
		case ORI:
			if(neg == true) {
				immediate = -immediate;
			}

			result = "0010" + registerConverter(this.rd) + extendBinary2(Integer.toBinaryString(immediate)) + '\n';
			break;
		case XOR:
			result = "0000" + registerConverter(this.rd) + "0011" + registerConverter(this.rs) +"\n";
			break;
		case XORI:
			if(neg == true) {
				immediate = -immediate;
			}
			result = "0011" + registerConverter(this.rd) + extendBinary2(Integer.toBinaryString(immediate)) + '\n';
			break;
		case MOV:
			result = "0000" + registerConverter(this.rd) + "1101" + registerConverter(this.rs) +"\n";
			break;
		case MOVI:
			if(neg == true) {
				immediate = -immediate;
			}
			result = "1101" + registerConverter(this.rd) + extendBinary2(Integer.toBinaryString(immediate)) + '\n';
			break;
		case LSH:
			result = "1000" + registerConverter(this.rd) + "0100" + registerConverter(this.rs) +"\n";
			break;
			//S is for sign extension
		case LSHI:
			int i = 0;
			if(neg == true) {
				immediate = -immediate;
			}
			i = checkSign(immediate);
			result = "1000" + registerConverter(this.rd) + "000" + i + extendBinary(Integer.toBinaryString(immediate)) + '\n';
			break;
		case LUI:
			if(neg == true) {
				immediate = -immediate;
			}
			result = "1111" + registerConverter(this.rd) + extendBinary2(Integer.toBinaryString(immediate)) + '\n';
			break;
		case LOAD:
			result = "0100" + registerConverter(this.rs) + "0000" + registerConverter(this.rd) + '\n';
			break;
		case STOR:
			result  = "0100" + registerConverter(this.rs) + "0100" + registerConverter(this.rd) + "\n";
			break;
		case BEQ:
			BcondD();
			result = "1100" + "0000" + extendBinary2(Integer.toBinaryString(immediate)) + '\n';
			break;
		case BNE:
			BcondD();
			result = "1100" + "0001" + extendBinary2(Integer.toBinaryString(immediate)) + '\n';
			break;
		case BCS:
			BcondD();
			result = "1100" + "0010" + extendBinary2(Integer.toBinaryString(immediate)) + '\n';
			break;
		case BCC:
			BcondD();
			result = "1100" + "0011" + extendBinary2(Integer.toBinaryString(immediate)) + '\n';
			break;
		case BHI:
			BcondD();
			result = "1100" + "0100" + extendBinary2(Integer.toBinaryString(immediate)) + '\n';
			break;
		case BLS:
			BcondD();
			result = "1100" + "0101" + extendBinary2(Integer.toBinaryString(immediate)) + '\n';
			break;
		case BGT:
			BcondD();
			result = "1100" + "0110" + extendBinary2(Integer.toBinaryString(immediate)) + '\n';
			break;
		case BLE:
			BcondD();
			result = "1100" + "0111" + extendBinary2(Integer.toBinaryString(immediate)) + '\n';
			break;
		case BFS:
			BcondD();
			result = "1100" + "1000" + extendBinary2(Integer.toBinaryString(immediate)) + '\n';
			break;
		case BFC:
			BcondD();
			result = "1100" + "1001" + extendBinary2(Integer.toBinaryString(immediate)) + '\n';
			break;
		case BLO:
			BcondD();
			result = "1100" + "1010" + extendBinary2(Integer.toBinaryString(immediate)) + '\n';
			break;
		case BHS:
			BcondD();
			result = "1100" + "1011" + extendBinary2(Integer.toBinaryString(immediate)) + '\n';
			break;
		case BLT:
			BcondD();
			result = "1100" + "1100" + extendBinary2(Integer.toBinaryString(immediate)) + '\n';
			break;
		case BGE:
			BcondD();
			result = "1100" + "1101" + extendBinary2(Integer.toBinaryString(immediate)) + '\n';
			break;
		case BUC:
			BcondD();
			result = "1100" + "1110" + extendBinary2(Integer.toBinaryString(immediate)) + '\n';
			break;
			//Jcond create here
		case JEQ:
			result = "0100" + "0000" + "1100" + registerConverter(this.rd) +"\n";
			break;
		case JNE:
			result = "0100" + "0001" + "1100" + registerConverter(this.rd) +"\n";
			break;
		case JCS:
			result = "0100" + "0010" + "1100" + registerConverter(this.rd) +"\n";
			break;
		case JCC:
			result = "0100" + "0011" + "1100" + registerConverter(this.rd) +"\n";
			break;
		case JHI:
			result = "0100" + "0100" + "1100" + registerConverter(this.rd) +"\n";
			break;
		case JLS:
			result = "0100" + "0101" + "1100" + registerConverter(this.rd) +"\n";
			break;
		case JGT:
			result = "0100" + "0110" + "1100" + registerConverter(this.rd) +"\n";
			break;
		case JLE:
			result = "0100" + "0111" + "1100" + registerConverter(this.rd) +"\n";
			break;
		case JFS:
			result = "0100" + "1000" + "1100" + registerConverter(this.rd) +"\n";
			break;
		case JFC:
			result = "0100" + "1001" + "1100" + registerConverter(this.rd) +"\n";
			break;
		case JLO:
			result = "0100" + "1010" + "1100" + registerConverter(this.rd) +"\n";
			break;
		case JHS:
			result = "0100" + "1011" + "1100" + registerConverter(this.rd) +"\n";
			break;
		case JLT:
			result = "0100" + "1100" + "1100" + registerConverter(this.rd) +"\n";
			break;
		case JGE:
			result = "0100" + "1101" + "1100" + registerConverter(this.rd) +"\n";
			break;
		case JUC:
			result = "0100" + "1110" + "1100" + registerConverter(this.rd) +"\n";
			break;
			//JAL
		case JAL:
			result = "0100" + registerConverter(this.rs) + "1000" + registerConverter(this.rd);
			break;
		case LDSD:
			break;
		case STSD:
			break;
		default:
			break;
		}
	}
	/**
	 * used for Bcond case
	 */
	public void BcondD (){
		if(immediate < 0 && isNumber == false) {
			neg = true;
		}
		if(neg == true && isNumber == true) {
			immediate = -immediate;
		}
	}
}
