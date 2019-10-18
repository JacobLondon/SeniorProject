#include "globals.hpp"

namespace Blastn {

// .fa and .fasta line seperator
char Seperator = '>';
// word length
u32 SplitLength = 11;

// min smith waterman score before filtering out
s32 SwMinscore = 20;
// smith waterman match score
s32 SwMatch = 2;
// smith waterman mismatch score
s32 SwMismatch = -1;
// smith waterman gap score
s32 SwGap = -1;
// ratio of max score to length
f32 SwRatio = 0; // SwMinscore / (SplitLength * SwMatch)

// dust threshold score before filtering out
f32 DustThreshold = 0.1f;
// length of patterns for dust to look for
u32 DustPatternLength = 3;

string QueryFile  = "../data/SRR7236689--ARG830.fa";
string DataFile   = "../data/Gn-SRR7236689_contigs.fasta";
string OutputDir = "blastn_out";
string OutputExt  = ".txt";

string TestQueryFile = "../data/small_query.fa";
string TestDataFile  = "../data/small_data.fasta";

} // Blastn