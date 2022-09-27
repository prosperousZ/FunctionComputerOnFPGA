package assembler;

import java.io.File;
import java.io.IOException;
import java.util.Dictionary;
import java.util.Hashtable;
import java.util.Scanner;

/**
 * This is the assembler class
 * @author Jeremy Zhang
 *
 */
public class label {
	
	public Dictionary<String, String>  label = new Hashtable<String, String>();
	/**
	 * check labels in assembly
	 */
	public void checkLabel() {
		try {
			int index = 0 ; 
			File file = new File(
					"C:\\Users\\zhz10\\labs\\FinalProject\\Assembler\\assembler\\assembler\\src\\assembler\\test1.asm");
			Scanner sc = new Scanner(file);
			
			while(sc.hasNextLine()) {
				String str = sc.nextLine();
				// deal with the white space
				if (str.length() == 0) {
					continue;
				}
				// Common situation
				if (str.contains("#")) {
					continue;
				}
				if (str.contains("@") && str.contains("LABEL")) {
					int ii = 0;
					String s = "";
					str = str.replaceAll("\\s", "");
					char[] STCA = str.toCharArray();
					while(STCA[ii] !='"') {
						ii++;
					}
					ii = ii+1;
					int iii = ii;
					while(STCA[iii] != '"') {
						iii++;
					}
					for(int i = ii; i < iii; i ++) {
						s = s+ STCA[i];
					}
					File file2 = new File(
							"C:\\Users\\zhz10\\labs\\FinalProject\\Assembler\\assembler\\assembler\\src\\assembler\\"+s);
					Scanner sc2 = new Scanner(file2);
					while(sc2.hasNextLine()) {
						String str2 = sc2.nextLine();
						String labelNa = "";
						String number = "";
						int q = 1;
						while(!str2.substring(q,q+1).equals("0")) {
							labelNa += str2.substring(q,q+1);
							q++;
						}
						labelNa = labelNa.replaceAll("\\s", "");
						q = q+2;
						for(;q < str2.length(); q++) {
							 number += str2.substring(q,q+1);
						}
						if(number.equals("0000")) {
							number = "0001";
						}
						label.put(labelNa,number);
					}
					sc2.close();
					continue;
				} 
				
				if(str.contains("@") && str.contains("START")) {
					continue;
				}

				index ++;
				String labelName = "";
				str = str.replaceAll("\\s", "");
				if(str.substring(0, 1).equals(".")) {
					for(int i = 1; i<str.length(); i ++) {
						labelName = labelName + str.substring(i, i+1);
					}
					label.put(labelName,Integer.toHexString(index));
					index = index-1;
					continue;
				}
				if(str.substring(0, 2).equals("JE")|| str.substring(0, 2).equals("JN")||str.substring(0, 2).equals("JC")||
						str.substring(0, 2).equals("JH")||str.substring(0, 2).equals("JL")||str.substring(0, 2).equals("JG")
						||str.substring(0, 2).equals("JF")||str.substring(0, 2).equals("JU") && (str.substring(3,4).equals("r"))) {
					index = index+2;
					continue;
				}
				int nu = 0;
				for(int j = 0; j < str.length(); j ++) {
					if(str.substring(j, j+1).equals(",")) {
						nu++;
					}
				}
				if(nu == 2) {
					index = index + 4;
					continue;
				}
				if((str.substring(0,1).equals("M") || str.substring(0,1).equals("L")) && str.contains(".") && (nu<2) ) {
					index = index + 3;
					continue;
				}
				//System.out.print(index + "\n");
			}
			//Small bug
			//System.out.print(label.toString() + "\n");
			//System.out.print(index + "\n");
			sc.close();
		}
		catch (IOException e) {
	}
	}

}
