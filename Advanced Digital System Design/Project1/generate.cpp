#include <iostream>
#include <fstream>
#include <string> 
#include <random>
#include <cstdlib>

using namespace std;

int main() {
    int number_circuits = 7;

    double inverter_nmos_L = 65;
    double inverter_nmos_W = 130;
    double nand_nmos_L = 65;
    double nand_nmos_W = 130;
    double inverter_pmos_L = 65;
    double inverter_pmos_W = 260;
    double nand_pmos_L = 65;
    double nand_pmos_W = 130;
    double TOXE = 3;
    double tplv = 0.15; //PMOS transistor length variation
    double tpwv = 0.15; //PMOS transistor width variation
    double tnln = 0.15; //NMOS transistor length variation
    double tnwn = 0.15; //NMOS transistor width variation
    double tpotv = 0.1; //PMOS transistor oxide layer thickness variation
    double tnotv = 0.1; //MOS transistor oxide layer thickness variation
    double processLW = 0.065; //Process for Length Width
    double processTOXE = 0.05; //Process for Oxide Layer

    //Gaussian Distribution Generator
    default_random_engine generator1(123);
    normal_distribution<double> W1(nand_nmos_W, nand_nmos_W * processLW); //130n Width Generator
    double Width1_Min = nand_nmos_W - nand_nmos_W * tpwv;
    double Width1_Max = nand_nmos_W + nand_nmos_W * tpwv;
    default_random_engine generator4(234);
    normal_distribution<double> W2(inverter_pmos_W, inverter_pmos_W * processLW); //260n Width Generator
    double Width2_Min = inverter_pmos_W - inverter_pmos_W * tpwv;
    double Width2_Max = inverter_pmos_W + inverter_pmos_W * tpwv;
    default_random_engine generator2(456);
    normal_distribution<double> L(nand_pmos_L, nand_pmos_L * processLW); //65n Length Generator
    double Length_Min = nand_pmos_L - nand_pmos_L * tplv;
    double Length_Max = nand_pmos_L + nand_pmos_L * tplv;
    default_random_engine generator3(789);
    normal_distribution<double> TOX(TOXE, TOXE * processTOXE); //Oxide Thickness Generator
    double TOXE_Min = TOXE - TOXE * tpotv;
    double TOXE_Max = TOXE + TOXE * tpotv;

    for(int i = 0; i <= number_circuits; i++)
    {
        // Open the .cir file for writing and truncate existing content
        string fileName = "ring_oscillator_" + to_string(i) + ".cir";
        ofstream outFile(fileName, ios::trunc);

        // Check if the file is opened successfully
        if (!outFile.is_open()) {
            cerr << "Error: Unable to open the file for writing." << endl;
            return 1; // Exit with error
        }
        //Write the content to the file
        //nand2
        outFile << "* " << i + 1 << " ring oscillator" << endl << endl;
        outFile << ".subckt " << i << "ring A B VDD VSS" << endl;
        outFile << "M1 Y A VDD VDD tp l=" << min(Length_Max, max(Length_Min, L(generator1))) << "n w=" << min(Width1_Max, max(Width1_Min, W1(generator1))) << "n" << endl;
        outFile << "M2 Y B VDD VDD tp l=" << min(Length_Max, max(Length_Min, L(generator1))) << "n w=" << min(Width1_Max, max(Width1_Min, W1(generator1))) << "n" << endl;
        outFile << "M3 Y A node1 VSS tn l=" << min(Length_Max, max(Length_Min, L(generator1))) << "n w=" << min(Width1_Max, max(Width1_Min, W1(generator1))) << "n" << endl;
        outFile << "M4 node1 B VSS VSS tn l=" << min(Length_Max, max(Length_Min, L(generator1))) << "n w=" << min(Width1_Max, max(Width1_Min, W1(generator1))) << "n" << endl << endl;

        //inverters
        for (int j = 5; j <= i + 4; j += 1)
        {
            if(j == i + 4)
            {
                outFile << "M" << 2 * j - 5 << " B" << " out" << j - 3 << " vdd vdd tp l=" << min(Length_Max, max(Length_Min, L(generator1))) << "n w=" << min(Width2_Max, max(Width2_Min, W2(generator4))) << "n" << endl;
                outFile << "M" << 2 * j - 4 << " B" << " out" << j - 3 << " vss vss tn l=" << min(Length_Max, max(Length_Min, L(generator1))) << "n w=" << min(Width1_Max, max(Width1_Min, W1(generator1))) << "n" << endl;
            }
            else if(j == 5)
            {
                outFile << "M" << 2 * j - 5 << " out" << j - 2 << " Y" << " vdd vdd tp l=" << min(Length_Max, max(Length_Min, L(generator1))) << "n w=" << min(Width2_Max, max(Width2_Min, W2(generator4))) << "n" << endl;
                outFile << "M" << 2 * j - 4 << " out" << j - 2 << " Y" << " vss vss tn l=" << min(Length_Max, max(Length_Min, L(generator1))) << "n w=" << min(Width1_Max, max(Width1_Min, W1(generator1))) << "n" << endl;
            }
            else
            {
                outFile << "M" << 2 * j - 5 << " out" << j - 2 << " out" << j - 3 << " vdd vdd tp l=" << min(Length_Max, max(Length_Min, L(generator1))) << "n w=" << min(Width2_Max, max(Width2_Min, W2(generator4))) << "n" << endl;
                outFile << "M" << 2 * j - 4 << " out" << j - 2 << " out" << j - 3 << " vss vss tn l=" << min(Length_Max, max(Length_Min, L(generator1))) << "n w=" << min(Width1_Max, max(Width1_Min, W1(generator1))) << "n" << endl;
            }
        }

        outFile << endl << ".model tp pmos level=54 version=4.8.2 TOXE=" << min(TOXE_Max, max(TOXE_Min, TOX(generator3))) << "n" << endl;
        outFile << ".model tn nmos level=54 version=4.8.2 TOXE=" << min(TOXE_Max, max(TOXE_Min, TOX(generator3))) << "n" << endl << endl;
        outFile << ".ends " << i + 1<< "ring" << endl;
        outFile.close();
        cout << "File '" << fileName << "' has been written successfully." << endl;
    }
    return 0;
}