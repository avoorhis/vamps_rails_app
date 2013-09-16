#encoding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# ["Linux", "Mac OS X", "Windows"].each do |os|
#   OperatingSystem.find_or_create_by_name os
# end

require "zlib"

users = User.create([{username: "Gordon", email: "jgordon@wustl.edu", institution: "Washington University School of Medicine", first_name: "Jeffrey", last_name: "Gordon", active: 1, security_level: 50, password: "e1ff14a173"},
  {username: "Relman", email: "relman@stanford.edu", institution: "Stanford University", first_name: "David", last_name: "Relman", active: 1, security_level: 50, password: "7436dbbf0b"},
  {username: "wscnsn", email: "mclellan@uwm.edu", institution: "University of Wisconsin-Madison", first_name: "Sandra", last_name: "McLellan", active: 1, security_level: 50, password: "d0d082b868"}
  ])

# "Gordon"	"jgordon@wustl.edu"	"Washington University School of Medicine"	"Jeffrey"	"Gordon"	"1"	"50"	"e1ff14a173834dbd4d487b7627196b30"	"NULL"	"NULL"	"NULL"	"0"	"NULL"	"NULL"	"NULL"	"NULL"	"NULL"	"2013-08-29 11:40:02"	"NULL"	"NULL"
# "Relman"	"relman@stanford.edu"	"Stanford University"	"David"	"Relman"	"1"	"50"	"7436dbbf0b2a49488e1d002da1f5fae7"	"NULL"	"NULL"	"NULL"	"0"	"NULL"	"NULL"	"NULL"	"NULL"	"NULL"	"2013-08-29 11:40:02"	"NULL"	"NULL"
# "wscnsn"	"mclellan@uwm.edu"	"University of Wisconsin-Madison"	"Sandra"	"McLellan"	"1"	"50"	"d0d082b868bf416b8a1db7e5a9b418ba"	"NULL"	"NULL"	"NULL"	"0"	"NULL"	"NULL"	"NULL"	"NULL"	"NULL"	"2013-08-29 11:40:02"	"NULL"	"NULL"

# TODO: add all fields

env_sample_sources = EnvSampleSource.create([
	{id:'1',env_sample_source_id: '0', env_source_name: ''},
	{id:'2',env_sample_source_id: '10', env_source_name: 'air'},
	{id:'3',env_sample_source_id: '20', env_source_name: 'extreme habitat'},
	{id:'4',env_sample_source_id: '30', env_source_name: 'host associated'},
	{id:'5',env_sample_source_id: '40', env_source_name: 'human associated'},
	{id:'6',env_sample_source_id: '41', env_source_name: 'human-skin'},
	{id:'7',env_sample_source_id: '42', env_source_name: 'human-oral'},
	{id:'8',env_sample_source_id: '43', env_source_name: 'human-gut'},
	{id:'9',env_sample_source_id: '44', env_source_name: 'human-vaginal'},
	{id:'10',env_sample_source_id: '45', env_source_name: 'human-amniotic-fluid'},
	{id:'11',env_sample_source_id: '46', env_source_name: 'human-urine'},
	{id:'12',env_sample_source_id: '47', env_source_name: 'human-blood'},	
	{id:'13',env_sample_source_id: '50', env_source_name: 'microbial mat/biofilm'},
	{id:'14',env_sample_source_id: '60', env_source_name: 'miscellaneous_natural_or_artificial_environment'},
	{id:'15',env_sample_source_id: '70', env_source_name: 'plant associated'},
	{id:'16',env_sample_source_id: '80', env_source_name: 'sediment'},
	{id:'17',env_sample_source_id: '90', env_source_name: 'soil/sand'},
	{id:'18',env_sample_source_id: '100', env_source_name: 'unknown'},
	{id:'19',env_sample_source_id: '110', env_source_name: 'wastewater/sludge'},
	{id:'20',env_sample_source_id: '120', env_source_name: 'water-freshwater'},
	{id:'21',env_sample_source_id: '130', env_source_name: 'water-marine'},
	{id:'22',env_sample_source_id: '140', env_source_name: 'indoor'}
	])


projects = Project.create([
	{id:'1',project: 'JPL_PHXF_Bv6', title: 'JPL facilities and Phoneix spacecraft', project_description: 'Planetary Protection assessment of JPL facilities and the Phoenix Spacecraft', rev_project_name: '6vB_FXHP_LPJ', funding: 'JetPropulsionLab CalTech',  user_id: '1'},
	{id:'2',project: 'BPC_MRB_C', title: 'cDNA sampling of Marinobacter', project_description: 'cDNA sampling of Marinobacter', rev_project_name: 'C_BRM_CPB', funding: 'pilot', user_id: '2'},
	{id:'3',project: 'KCK_MHB_Bv6', title: 'Mount Hope Bay - winter and summer', project_description: 'Mount Hope Bay - winter and summer study', rev_project_name: '6vB_BHM_KCK', funding: 'Keck', user_id: '3'},
	{id:'4',project: 'BPC_TAM_Av6v4', title: 'taxrix', project_description: 'tamrix bush', rev_project_name: '4v6vA_MAT_CPB', funding: 'Keck', user_id: '3'},
	{id:'5',project: 'ICM_GMS_Av6', title: 'icomm gms', project_description: 'icomm gms desc', rev_project_name: '6vA_SMG_MCI', funding: 'Keck', user_id: '1'}
	])


datasets = Dataset.create([
	{id:'1',dataset: '0002_SP2_2.2m', dataset_description: '0002_SP-2_2.2m',env_sample_source_id:'3',project_id:'1'},
	{id:'2',dataset: '0003_JW76',     dataset_description: '0003_JW76',env_sample_source_id:'22',project_id:'2'},
	{id:'3',dataset: '0003_SP3_2.9m', dataset_description: '0003_SP-3_2.9m',env_sample_source_id:'22',project_id:'3'},
	{id:'4',dataset: 'TMX_1', dataset_description: '0003_SP-3_2.9m',env_sample_source_id:'16',project_id:'4'},
	{id:'5',dataset: 'TMX_2', dataset_description: '0003_SP-3_2.9m',env_sample_source_id:'16',project_id:'4'},
	{id:'6',dataset: 'GMS_0018_2008_12_07', dataset_description: '0003_SP-3_2.9m',env_sample_source_id:'16',project_id:'5'},
	{id:'7',dataset: 'GMS_0020_2008_12_07', dataset_description: '0003_SP-3_2.9m',env_sample_source_id:'16',project_id:'5'}
	])

ranks = Rank.create([
	{id:'1',rank: "domain"}, 
	{id:'2',rank: "phylum"}, 
	{id:'3',rank: "class"}, 
	{id:'4',rank: "order"}, 
	{id:'5',rank: "family"}, 
	{id:'6',rank: "genus"}, 
	{id:'7',rank: "species"}, 
	{id:'8',rank: "strain"}, 
	{id:'20',rank:  "NA"}, 
	
	{id:'21',rank: "orderx"}, 
	{id:'22',rank: "superkingdom"}
	])


# TAM: select * from vamps_export where taxonomy like 'Archaea;Euryarchaeota;Halobacteria;Halobacteriales;Halobacteriaceae;Haloferax%'

taxonomies_old = Taxonomy.create([
	{id:"1",taxonomy: 'Archaea;Crenarchaeota;Thermoprotei;Desulfurococcales;Desulfurococcaceae;Unassigned;uncultured crenarchaeote pBA3'},
	{id:"2",taxonomy: 'Archaea;Crenarchaeota;Thermoprotei;Desulfurococcales;Desulfurococcaceae;Unassigned;uncultured Desulfurococcaceae archaeon'},
	{id:"3",taxonomy: 'Archaea;Crenarchaeota;Thermoprotei;Desulfurococcales;environmental samples'},
	{id:"4",taxonomy: 'Archaea;Crenarchaeota;Thermoprotei;Desulfurococcales;Ignisphaera'},
	{id:"5",taxonomy: 'Archaea;Crenarchaeota;Thermoprotei;Desulfurococcales;Pyrodictiaceae'},
	{id:"6",taxonomy: 'Archaea;Crenarchaeota;Thermoprotei;Desulfurococcales;Pyrodictiaceae;Geogemma'},
	{id:"7",taxonomy: 'Archaea;Crenarchaeota;Thermoprotei;Desulfurococcales;Pyrodictiaceae;Geogemma;Geogemma indica'},
	{id:"8",taxonomy: 'Archaea;Crenarchaeota;Thermoprotei;Desulfurococcales;Pyrodictiaceae;Geogemma;Geogemma pacifica'},
	{id:"9",taxonomy: 'Archaea;Crenarchaeota;Thermoprotei;Desulfurococcales;Pyrodictiaceae;Hyperthermus'},
	{id:"10",taxonomy: 'Archaea;Crenarchaeota;Thermoprotei;Desulfurococcales;Pyrodictiaceae;Hyperthermus;butylicus'},
	{id:"11",taxonomy: 'Archaea;Crenarchaeota;Thermoprotei;Desulfurococcales;Pyrodictiaceae;Hyperthermus;butylicus;DSM 5456'},
	{id:"12",taxonomy: 'Archaea;Crenarchaeota;Thermoprotei;Desulfurococcales;Pyrodictiaceae;Hyperthermus;Hyperthermus butylicus'},
	{id:"13",taxonomy: 'Archaea;Crenarchaeota;Thermoprotei;Desulfurococcales;Pyrodictiaceae;Hyperthermus;uncultured Hyperthermus sp.'},
	{id:"14",taxonomy: 'Archaea;Crenarchaeota;Thermoprotei;Desulfurococcales;Pyrodictiaceae;Pyrodictium'},
	{id:"15",taxonomy: 'Archaea;Crenarchaeota;Thermoprotei;Desulfurococcales;Pyrodictiaceae;Pyrodictium;abyssi'},
	{id:"16",taxonomy: 'Archaea;Crenarchaeota;Thermoprotei;Desulfurococcales;Pyrodictiaceae;Pyrodictium;brockii'},
	{id:"17",taxonomy: 'Archaea;Crenarchaeota;Thermoprotei;Desulfurococcales;Pyrodictiaceae;Pyrodictium;environmental samples'},
	{id:"18",taxonomy: 'Archaea;Euryarchaeota;Halobacteria;Halobacteriales;Halobacteriaceae;Halococcus;Halococcus sp. BIGigoW09'},
	{id:"19",taxonomy: 'Archaea;Euryarchaeota;Halobacteria;Halobacteriales;Halobacteriaceae;Halococcus;Halococcus sp. BIHTY10/11'},
	{id:"20",taxonomy: 'Archaea;Euryarchaeota;Halobacteria;Halobacteriales;Halobacteriaceae;Halococcus;Halococcus sp. HPA-86'},
	{id:"21",taxonomy: 'Archaea;Euryarchaeota;Halobacteria;Halobacteriales;Halobacteriaceae;Halococcus;Halococcus sp. HPA-87'},
	{id:"22",taxonomy: 'Archaea;Euryarchaeota;Halobacteria;Halobacteriales;Halobacteriaceae;Halococcus;Halococcus sp. HSA18'},
	{id:"23",taxonomy: 'Archaea;Euryarchaeota;Halobacteria;Halobacteriales;Halobacteriaceae;Halococcus;Halococcus sp. HSA19'},
	{id:"24",taxonomy: 'Archaea;Euryarchaeota;Halobacteria;Halobacteriales;Halobacteriaceae;Halococcus;Halococcus sp. HSA20'},
	{id:"25",taxonomy: 'Archaea;Euryarchaeota;Halobacteria;Halobacteriales;Halobacteriaceae;Halococcus;Halococcus sp. IS10-2'},
	{id:"26",taxonomy: 'Archaea;Euryarchaeota;Halobacteria;Halobacteriales;Halobacteriaceae;Halococcus;Halococcus sp. JCM 8979'},
	{id:"27",taxonomy: 'Archaea;Euryarchaeota;Halobacteria;Halobacteriales;Halobacteriaceae;Halococcus;Halococcus thailandensis'},
	{id:"28",taxonomy: 'Archaea;Euryarchaeota;Halobacteria;Halobacteriales;Halobacteriaceae;Halococcus;hamelinensis'},
	{id:"29",taxonomy: 'Archaea;Euryarchaeota;Halobacteria;Halobacteriales;Halobacteriaceae;Halococcus;morrhuae'},
	{id:"30",taxonomy: 'Archaea;Euryarchaeota;Halobacteria;Halobacteriales;Halobacteriaceae;Halococcus;qingdaonensis'},
	{id:"31",taxonomy: 'Archaea;Euryarchaeota;Halobacteria;Halobacteriales;Halobacteriaceae;Halococcus;saccharolyticus'},
	{id:"32",taxonomy: 'Archaea;Euryarchaeota;Halobacteria;Halobacteriales;Halobacteriaceae;Halococcus;salifodinae'},
	{id:"33",taxonomy: 'Archaea;Euryarchaeota;Halobacteria;Halobacteriales;Halobacteriaceae;Halococcus;thailandensis'},
	{id:"34",taxonomy: 'Archaea;Euryarchaeota;Halobacteria;Halobacteriales;Halobacteriaceae;Halococcus;turkmenicus'},
	{id:"35",taxonomy: 'Archaea;Euryarchaeota;Halobacteria;Halobacteriales;Halobacteriaceae;Halococcus;uncultured Halococcus sp.'},
	{id:"36",taxonomy: 'Archaea;Euryarchaeota;Halobacteria;Halobacteriales;Halobacteriaceae;Haloferax'},
	{id:"37",taxonomy: 'Bacteria;Proteobacteria;Gammaproteobacteria;Pseudomonadales;Pseudomonadaceae;Pseudomonas;Pseudomonas sp. DH-6'},
	{id:"38",taxonomy: 'Bacteria;Proteobacteria;Gammaproteobacteria;Pseudomonadales;Pseudomonadaceae;Pseudomonas;Pseudomonas sp. DH2001'},
	{id:"39",taxonomy: 'Bacteria;Proteobacteria;Gammaproteobacteria;Pseudomonadales;Pseudomonadaceae;Pseudomonas;Pseudomonas sp. DH24-2'},
	{id:"40",taxonomy: 'Bacteria;Proteobacteria;Gammaproteobacteria;Pseudomonadales;Pseudomonadaceae;Pseudomonas;Pseudomonas sp. DH27-2'},
	{id:"41",taxonomy: 'Bacteria;Proteobacteria;Gammaproteobacteria;Pseudomonadales;Pseudomonadaceae;Pseudomonas;Pseudomonas sp. DH38-2'},
	{id:"42",taxonomy: 'Bacteria;Proteobacteria;Gammaproteobacteria;Pseudomonadales;Pseudomonadaceae;Pseudomonas;Pseudomonas sp. DH93-2'},
	{id:"43",taxonomy: 'Bacteria;Proteobacteria;Gammaproteobacteria;Pseudomonadales;Pseudomonadaceae;Pseudomonas;Pseudomonas sp. DhA-51'},
	{id:"44",taxonomy: 'Bacteria;Proteobacteria;Gammaproteobacteria;Pseudomonadales;Pseudomonadaceae;Pseudomonas;Pseudomonas sp. DhA-91'},
	{id:"45",taxonomy: 'Bacteria;Proteobacteria;Gammaproteobacteria;Pseudomonadales;Pseudomonadaceae;Pseudomonas;Pseudomonas sp. DHHS2'},
	{id:"46",taxonomy: 'Bacteria;Proteobacteria;Gammaproteobacteria;Pseudomonadales;Pseudomonadaceae;Pseudomonas;Pseudomonas sp. DHS3Y'},
	{id:"47",taxonomy: 'Bacteria;Proteobacteria;Gammaproteobacteria;Pseudomonadales;Pseudomonadaceae;Pseudomonas;Pseudomonas sp. DHT2'},
	{id:"48",taxonomy: 'Bacteria;Proteobacteria;Gammaproteobacteria;Pseudomonadales;Pseudomonadaceae;Pseudomonas;Pseudomonas sp. dI1'},
	{id:"49",taxonomy: 'Bacteria;Proteobacteria;Gammaproteobacteria;Pseudomonadales;Pseudomonadaceae;Pseudomonas;Pseudomonas sp. dI14'},
	{id:"50",taxonomy: 'Bacteria;Proteobacteria;Gammaproteobacteria;Pseudomonadales;Pseudomonadaceae;Pseudomonas;Pseudomonas sp. DJCJ55'},
	{id:"51",taxonomy: 'Bacteria;Proteobacteria;Gammaproteobacteria;Pseudomonadales;Pseudomonadaceae;Pseudomonas;Pseudomonas sp. DJCJ69'},
	{id:"52",taxonomy: 'Bacteria;Proteobacteria;Gammaproteobacteria;Pseudomonadales;Pseudomonadaceae;Pseudomonas;Pseudomonas sp. DJF1'},
	{id:"53",taxonomy: 'Bacteria;Proteobacteria;Gammaproteobacteria;Pseudomonadales;Pseudomonadaceae;Pseudomonas;Pseudomonas sp. DJFZ'},
	{id:"54",taxonomy: 'Bacteria;Proteobacteria;Gammaproteobacteria;Pseudomonadales;Pseudomonadaceae;Pseudomonas;Pseudomonas sp. DJHH69'},
	{id:"55",taxonomy: 'Bacteria;Proteobacteria;Gammaproteobacteria;Pseudomonadales;Pseudomonadaceae;Pseudomonas;Pseudomonas sp. DJHH74'},
	{id:"56",taxonomy: 'Bacteria;Proteobacteria;Gammaproteobacteria;Pseudomonadales;Pseudomonadaceae;Pseudomonas;Pseudomonas sp. DJWH11'},
	{id:"57",taxonomy: 'Eukarya;Streptophyta;Unassigned;Caryophyllales;Nyctaginaceae;Acleisanthes;Acleisanthes wrightii'},
	{id:"58",taxonomy: 'Eukarya;Streptophyta;Unassigned;Caryophyllales;Nyctaginaceae;Allionia'},
	{id:"59",taxonomy: 'Eukarya;Streptophyta;Unassigned;Caryophyllales;Nyctaginaceae;Allionia;Allionia choisyi'},
	{id:"60",taxonomy: 'Eukarya;Streptophyta;Unassigned;Caryophyllales;Nyctaginaceae;Allionia;Allionia incarnata'},
	{id:"61",taxonomy: 'Eukarya;Streptophyta;Unassigned;Caryophyllales;Nyctaginaceae;Andradea'},
	{id:"62",taxonomy: 'Eukarya;Streptophyta;Unassigned;Caryophyllales;Nyctaginaceae;Andradea;Andradea floribunda'},
	{id:"63",taxonomy: 'Eukarya;Streptophyta;Unassigned;Caryophyllales;Nyctaginaceae;Anulocaulis'},
	{id:"64",taxonomy: 'Eukarya;Streptophyta;Unassigned;Caryophyllales;Nyctaginaceae;Anulocaulis;Anulocaulis annulatus'},
	{id:"65",taxonomy: 'Eukarya;Streptophyta;Unassigned;Caryophyllales;Nyctaginaceae;Anulocaulis;Anulocaulis eriosolenus'},
	{id:"66",taxonomy: 'Eukarya;Streptophyta;Unassigned;Caryophyllales;Nyctaginaceae;Anulocaulis;Anulocaulis leiosolenus'},
	{id:"67",taxonomy: 'Eukarya;Streptophyta;Unassigned;Caryophyllales;Nyctaginaceae;Anulocaulis;Anulocaulis reflexus'},
	{id:"68",taxonomy: 'Eukarya;Streptophyta;Unassigned;Caryophyllales;Nyctaginaceae;Belemia'},
	{id:"69",taxonomy: 'Eukarya;Streptophyta;Unassigned;Caryophyllales;Nyctaginaceae;Belemia;Belemia fucsioides'},
	{id:"70",taxonomy: 'Eukarya;Streptophyta;Unassigned;Caryophyllales;Nyctaginaceae;Boerhavia'},
	{id:"71",taxonomy: 'Eukarya;Streptophyta;Unassigned;Caryophyllales;Nyctaginaceae;Boerhavia;Boerhavia anisophylla'},
	{id:"72",taxonomy: 'Eukarya;Streptophyta;Unassigned;Caryophyllales;Nyctaginaceae;Boerhavia;Boerhavia ciliata'},
	{id:"73",taxonomy: 'Eukarya;Streptophyta;Unassigned;Caryophyllales;Nyctaginaceae;Boerhavia;Boerhavia coccinea'},
	{id:"74",taxonomy: 'Eukarya;Streptophyta;Unassigned;Caryophyllales;Nyctaginaceae;Boerhavia;Boerhavia coulteri'},
	{id:"75",taxonomy: 'Eukarya;Streptophyta;Unassigned;Caryophyllales;Nyctaginaceae;Boerhavia;Boerhavia dominii'},
	{id:"76",taxonomy: 'Eukarya;Streptophyta;Unassigned;Caryophyllales;Nyctaginaceae;Boerhavia;Boerhavia erecta'},
	{id:"77",taxonomy: 'Archaea'},
	{id:"78",taxonomy: 'Archaea;Crenarchaeota'},
	{id:"79",taxonomy: 'Archaea;Crenarchaeota;Thermoprotei'},
	{id:"80",taxonomy: 'Archaea;Crenarchaeota;Thermoprotei;Desulfurococcales'},
	{id:"81",taxonomy: 'Bacteria'},
	{id:"82",taxonomy: 'Bacteria;Proteobacteria'},
	{id:"83",taxonomy: 'Bacteria;Proteobacteria;Gammaproteobacteria'},
	{id:"84",taxonomy: 'Bacteria;Proteobacteria;Gammaproteobacteria;Pseudomonadales'},
	{id:"85",taxonomy: 'Eukarya'},
	{id:"86",taxonomy: 'Eukarya;Streptophyta'},
	{id:"87",taxonomy: 'Eukarya;Streptophyta;Unassigned'},
	{id:"88",taxonomy: 'Eukarya;Streptophyta;Unassigned;Caryophyllales'}

	])

# todo: sequence_pdr_infos
# todo: sequence_uniq_infos
# TAM: select * from vamps_export where taxonomy like 'Archaea;Euryarchaeota;Halobacteria;Halobacteriales;Halobacteriaceae;Haloferax%'

sequences = Sequence.create([
	{id:"1",sequence_comp: Zlib::Deflate.deflate('GTAGGAGTGAAATCCCGTAATCCTGGACGACCGCCGATGGACGAAGCACCTCGAGAAGACGGACCCGACGGTGAGGGACGAAAGCCAGGGTCTCGAACCGGATTAGATACCCGGGTAGTCCTAGCCGTAAACGATGTTCGTTAGGTGTGGCACTGGCTACGAGCCAGTGCTGTGCCGTAGGGAAGCCGAGAAACGAACCGCCTGGGAAGTACGTCTGCAAGGATGAAACTTAAAGGAATTGGCGGGGGAGCACTACAACCGGAGGAGCCTGCGGTTTAATTGGACTCAACGCCGGACATCTCACCAGCTCCGACTACAGTGATGACGATCAGGTTGATGACCTCATCACGACGCTGTAGAGAG')},
	{id:"2",sequence_comp: Zlib::Deflate.deflate('GTAGGAGTGAAATCCCGTAATCCTGGACGGACCACCGGTGGACGAAAGCGCCTCGGGAAGATGGATCCGACGGTGAGGGACGAAAGCTAGGGTCACGAACCGGATTAGATACCCGGGTAGTCCTAGCCGTAAACGATGTTCGTTAGGTGTGGCACTGGCTACGAGCCAGTGCTGTGCCGTAGGGAAGCCGAGAAACGAACCGCCTGGGAAGTACGTCTGCAAGGATAGAAACTTAAAGGAATTGGCGGGGGAGCACTACAACCGGAGGAGCCTGCGGTTTAATTGGACTCAACGCCGGACATCTCACCAGCTCCGACTACAGTGATGACGATCAGGTTGATGACCTCATCACGACGCTGTAGAGAG')},
	{id:"3",sequence_comp: Zlib::Deflate.deflate('GTAGGAGTGAAATCCCGTAATCCTGGACGGACCACCGATGGCGAAAGCACTTCGAGAGAACTGATCCGACGGTGAGGGACGAAAGCTAGGGTCTCGAACCGGATTACCCGATACCCGGGTAGTCCTAGCCGTAAACGATGTTCGCTAGGTGTGGCACTGGCTACGAGCCAGTGCTGTGCCGTAGGGAAGCCGAGAAGCGAACCGCCTGGGAAGTACGTCTGCAAGGATGAAACTTAAAGGAATTGGCGGGGGAGCACTACAACCGGAGGAGCCTGCGGTTTAATTGGACTCAGCGCCGGACATCTCACCAGCTCCGACTACAGTGATGACGATCAGGTTGATGACCTCATCACGACGCTGTAGAGAG')},
	{id:"4",sequence_comp: Zlib::Deflate.deflate('GTAGGAGTGAAATCCCGTAATCCTGGACGGACCGCCGATGGCGAAAGCACCTCGGGAGGACGGATCCGACGGTGAGGGACGAAAGCTAGGGTCTCGAACCGGATTAGATACCCGGGTAGTCCTAGCCGTAAACGATGTTCGTTAGGTGTGGGCACTGGCTACGAGCCAGTGCTGTGCCGTAGGGAAGCCGAGAAGCGAAACCGCCTGGGAAGTACGTCTGCAAGGATGAAACTTAAAGGAATTGGCGGGGGAGCACTACAACCGGAGGAGCCTGCGGTTTAATTGGACTCAACGCCGGACATCTCACCAGCTCCGACTACAGTGATGACGATCAGGTTGATGACCTCATACACGACGCTGTAGAGAG')},
	{id:"5",sequence_comp: Zlib::Deflate.deflate('GAACCTTACCGGGGCGACAGCAGGATGACGGCCAGGCTAAAGGCCTTGCCCGACGCGCTGAGAG')},
	{id:"6",sequence_comp: Zlib::Deflate.deflate('GAACCTTACCGGGGCGACAGCAGGATGACGGCCAGGCTAAAGGCCTTGCCCGACGCGCTGAGAT')},
	{id:"7",sequence_comp: Zlib::Deflate.deflate('GAACCTTACCGGGGGCGACAGCAGGATGACGGCCAGGCTAAGGCCTTGCCCGACGCGCTGAGAG')},
	{id:"8",sequence_comp: Zlib::Deflate.deflate('GAACCTCACCGGGGGCGACAGCAGGATGACGGCCAGGTTGAAGGCCTTGCCCGACGCGCTGAGA')},
	{id:"9",sequence_comp: Zlib::Deflate.deflate('AACCTCACCGGGGGCGACAGCAGGATGACGGCCAGGTTGAAGGCCTTGCCCGACGCGCTGAGAG')},
	{id:"10",sequence_comp: Zlib::Deflate.deflate('GAACCTCACCGGGGCGACAGCAGGATGACGGCCAGGTTGAAGGCCTTGCCCGACGCGCTGAGAG')}
	])
# first 4 sequences are taxonomy 36: Archaea;Euryarchaeota;Halobacteria;Halobacteriales;Halobacteriaceae;Haloferax
sequence_uniq_infos = SequenceUniqInfo.create([
	{sequence_id:'1',taxonomy_id: '36', read_length:'363', gast_distance:'0.03300',refssu_id:'--',  refssu_count: '0',  rank_id: '6',  refhvr_ids: 'v4v6a_GG549 v4v6a_GG640'},
	{sequence_id:'2',taxonomy_id: '36', read_length:'366',gast_distance:'0.04900',refssu_id:'--',  refssu_count: '0',  rank_id: '6',  refhvr_ids: 'v4v6a_GG640'},
	{sequence_id:'3',taxonomy_id: '36', read_length:'367', gast_distance:'0.04100',refssu_id:'--',  refssu_count: '0',  rank_id: '6',  refhvr_ids: 'v4v6a_GG640'},
	{sequence_id:'4',taxonomy_id: '36', read_length:'367',gast_distance:'0.03000',refssu_id:'--',  refssu_count: '0',  rank_id: '6',  refhvr_ids: 'v4v6a_GG640'},
	{sequence_id:'5',taxonomy_id: '14', read_length:'64',gast_distance:'0.04100',refssu_id:'--',  refssu_count: '0',  rank_id: '5',  refhvr_ids: 'v6a_CB919'},
	{sequence_id:'6',taxonomy_id: '14', read_length:'64',gast_distance:'0.04100',refssu_id:'--',  refssu_count: '0',  rank_id: '5',  refhvr_ids: 'v6a_CB919'},
	{sequence_id:'7',taxonomy_id: '14', read_length:'64',gast_distance:'0.04100',refssu_id:'--',  refssu_count: '0',  rank_id: '5',  refhvr_ids: 'v6a_CB919'},
	{sequence_id:'8',taxonomy_id: '14', read_length:'64',gast_distance:'0.04100',refssu_id:'--',  refssu_count: '0',  rank_id: '5',  refhvr_ids: 'v6a_CB919'},
	{sequence_id:'9',taxonomy_id: '14', read_length:'64',gast_distance:'0.04100',refssu_id:'--',  refssu_count: '0',  rank_id: '5',  refhvr_ids: 'v6a_CB919'},
	{sequence_id:'10',taxonomy_id: '14', read_length:'64',gast_distance:'0.04600',refssu_id:'--',  refssu_count: '0',  rank_id: '5',  refhvr_ids: 'v6a_CB919'}
	])



sequence_pdr_infos = SequencePdrInfo.create([
	{sequence_id:'1', seq_count: '36', dataset_id:'1', project_id:'1'},
	{sequence_id:'2', seq_count: '36', dataset_id:'1', project_id:'1'},
	{sequence_id:'3', seq_count: '36', dataset_id:'1', project_id:'1'},
	{sequence_id:'4', seq_count: '36', dataset_id:'1', project_id:'1'},
	{sequence_id:'5', seq_count: '36', dataset_id:'1', project_id:'1'},
	{sequence_id:'6', seq_count: '36', dataset_id:'1', project_id:'1'},
	{sequence_id:'35', seq_count: '36', dataset_id:'4', project_id:'4'},
	{sequence_id:'36', seq_count: '36', dataset_id:'5', project_id:'4'},
	{sequence_id:'9', seq_count: '36', dataset_id:'6', project_id:'5'},
	{sequence_id:'10',seq_count: '36', dataset_id:'7', project_id:'5'}
	])
