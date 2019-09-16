from sys import argv
from typing import Dict, List

from lib import dust_filter, \
                extend_filter, Extended, \
                get_exact_matches, MatchStruct, \
                pair_filter, AdjacentPair, \
                prepare_sequence, build_sequence, \
                smith_waterman_filter, \
                sort_filter, \
                split_to_words

def blastn(query_file, data_file, split_len, minscore, dust_threshold, sw_match, sw_mismatch, sw_gap):
    # format data into a dictionary
    # {name : {word : [indices], word : [indices], ...}, ...}
    print('Formatting...')
    query: Dict[str, str] \
        = build_sequence(path=query_file)
    data: Dict[str, str] \
        = build_sequence(path=data_file)
    prepared_query: Dict[str, Dict[str, List[int]]] \
        = prepare_sequence(path=query_file,
                           length=split_len)
    prepared_data: Dict[str, Dict[str, List[int]]] \
        = prepare_sequence(path=data_file,
                           length=split_len)

    # remove low scoring query words
    print('Smith Waterman...')
    scored_query: Dict[str, Dict[str, List[int]]] \
        = smith_waterman_filter(data=prepared_query,
                                minscore=minscore,
                                match=sw_match,
                                mismatch=sw_mismatch,
                                gap=sw_gap)

    # dust filter out words below the threshold
    print('Dust...')
    filtered_query: Dict[str, Dict[str, List[int]]] \
        = scored_query
    """= dust_filter(data=scored_query,
                    threshold=dust_threshold,
                    word_len=split_len)"""

    # find all exact matches of every filtered_query in formatted_data
    # {dname : {qname : [Match(word, dindices, qindices), ...], ...}, ...}
    print('Exact matches...')
    exact_matches: Dict[str, Dict[str, List[MatchStruct]]] \
        = get_exact_matches(query=filtered_query,
                            data=prepared_data)
    # print the exact matches
    if exact_matches is None:
        print('No results.')
        return
    
    adjacent_pairs: Dict[str, Dict[str, List[AdjacentPair]]] \
        = pair_filter(matches=exact_matches,
                      query=query)

    extended_pairs: Dict[str, Dict[str, List[Extended]]] \
        = extend_filter(pairs=adjacent_pairs,
                        query=query,
                        data=data,
                        minscore=minscore,
                        match=sw_match,
                        mismatch=sw_mismatch,
                        gap=sw_gap)
    
    sorted_epairs: Dict[str, Dict[str, List[Extended]]] \
        = sort_filter(extended_pairs=extended_pairs,
                      query=query,
                      match=sw_gap,
                      mismatch=sw_match,
                      gap=sw_gap)
    
    

    print('filtered_query\n', filtered_query)
    print('Exact matches\n', exact_matches)
    print('Adjacent pairs\n', adjacent_pairs)
    print('Extended\n', extended_pairs)
    print('Sorted\n', sorted_epairs)

    """print('Writing output...')
    builder = ''
    for data_name, queries in exact_matches.items():
        for query_name, match_structs in queries.items():
            for match_struct in match_structs:
                builder += f"'{match_struct.word}'\t" \
                        + f"{data_name}{match_struct.data_indices}\t" \
                        + f"{query_name}{match_struct.query_indices}\n"
    with open('blastn_out.txt', 'w') as blastn_out:
        blastn_out.write(builder)"""
    
    print('...done')

"""
input arg example:
python main.py -q ../data/query_small.fa -db ../data/data_small.fasta -l 4 -m 5 -dt .5 -ma 2 -mi -1 -g -1
python3 main.py -q ../data/SRR7236689--ARG830.fa -db ../data/Gn-SRR7236689_contigs.fasta -l 11 -m 2 -dt .2 -ma 2 -mi -1 -g -1
"""
if __name__ == '__main__':
    query_file = "../data/query_small.fa"
    #query_file = "../data/SRR7236689--ARG830.fa"
    data_file = "../data/data_small.fasta"
    #data_file = "../data/Gn-SRR7236689_contigs.fasta"
    split_len = 3
    # if below
    minscore = 0
    # if below, dust removes
    dust_threshold = 0
    sw_match = 2
    sw_mismatch = -1
    sw_gap = -1

    args = iter(argv)
    try:
        for arg in args:
            if arg == '-q':
                query_file = next(args)
            elif arg == '-db':
                data_file = next(args)
            elif arg == '-l':
                split_len = int(next(args))
            elif arg == '-m':
                minscore = int(next(args))
            elif arg == '-dt':
                dust_threshold = float(next(args))
            elif arg == '-ma':
                sw_match = int(next(args))
            elif arg == '-mi':
                sw_mismatch = int(next(args))
            elif arg == '-g':
                sw_gap = int(next(args))
    except:
        print('Failure: invalid argument(s)')
        exit(-1)

    blastn(query_file=query_file,
           data_file=data_file,
           split_len=split_len,
           minscore=minscore,
           dust_threshold=dust_threshold,
           sw_match=sw_match,
           sw_mismatch=sw_mismatch,
           sw_gap=sw_gap)
