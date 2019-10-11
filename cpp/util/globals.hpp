#pragma once
#include "types.hpp"

/**
 * Global variables
 */

namespace Blastn {

extern char Seperator;           // .fa and .fasta line seperator
extern u32 SplitLength;          // word length

extern s32 SwMinscore;           // min smith waterman score before filtering out
extern s32 SwMatch;              // smith waterman match score
extern s32 SwMismatch;           // smith waterman mismatch score
extern s32 SwGap;                // smith waterman gap score
extern f32 SwRatio;              // smith waterman ratio of max score to word length

extern f32 DustThreshold;        // dust threshold score before filtering out
extern u32 DustPatternLength;    // length of patterns for dust to look for

extern string QueryFile;
extern string DataFile;
extern string OutputFile;

extern string LTestQuery;
extern string STestQuery;
extern string LTestData;
extern string STestData;

} // Blastn