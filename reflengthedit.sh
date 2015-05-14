use Bio::SeqIO;
$in  = Bio::SeqIO->new(-file => "Vcarteri_v2_PseudoFemale_3-13-15.fa", -format => 'Fasta');
$out = Bio::SeqIO->new(-file => ">Vcarteri_v2_PseudoFemale_3-13-15-edit.fa",-format => 'Fasta');
while ( my $seq = $in->next_seq() ) {$out->write_seq($seq); }
