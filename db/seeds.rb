#encoding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

contacts = Contact.create([{contact: 'Elizabeth McCliment', email: 'lmccliment@mbl.edu', institution: 'MBL', vamps_name: 'lmccliment', first_name: 'Elizabeth', last_name:'McCliment'},
{contact: 'Jeffrey Gordon', email: 'jgordon@wustl.edu', institution: 'Washington University School of Medicine', vamps_name: 'Gordon', first_name: 'Jeffrey', last_name:'Gordon'},
{contact: 'David Relman', email: 'relman@stanford.edu', institution: 'Stanford University', vamps_name: 'Relman', first_name: 'David', last_name:'Relman'}])

# TODO: add all fields
datasets = Dataset.create([{dataset: '0002_SP2_2.2m', dataset_description: '0002_SP-2_2.2m'},
{dataset: '0003_JW76',     dataset_description: '0003_JW76'},
{dataset: '0003_SP3_2.9m', dataset_description: '0003_SP-3_2.9m'}])

dna_regions = DnaRegion.create([{dna_region: '2'},
{dna_region: 'cDNA'},
{dna_region: 'ditag'},
{dna_region: 'Entrez Genome'},
{dna_region: 'EST'},
{dna_region: 'fosmid'},
{dna_region: 'genomic'},
{dna_region: 'genomic dna'},
{dna_region: 'Glockner, Amsterdam'},
{dna_region: 'Hugenholtz'},
{dna_region: 'ICNB'},
{dna_region: 'ITS1'},
{dna_region: 'MBL'},
{dna_region: 'NCBI'},
{dna_region: 'RDP'},
{dna_region: 'Silva'},
{dna_region: 'Sogin, August 2008'},
{dna_region: 'v3'},
{dna_region: 'v3v1'},
{dna_region: 'v3v5'},
{dna_region: 'v3v6'},
{dna_region: 'v4'},
{dna_region: 'v4v5'},
{dna_region: 'v4v6'},
{dna_region: 'v5v3'},
{dna_region: 'v5v4'},
{dna_region: 'v6'},
{dna_region: 'v6a'},
{dna_region: 'v6v4'},
{dna_region: 'v6v4a'},
{dna_region: 'v6_dutch'},
{dna_region: 'v9'},
{dna_region: 'v9v6'}])

env_sample_sources = EnvSampleSource.create([{env_sample_source_id: '0', env_source_name: ''},
{env_sample_source_id: '10', env_source_name: 'air'},
{env_sample_source_id: '20', env_source_name: 'extreme habitat'},
{env_sample_source_id: '30', env_source_name: 'host associated'},
{env_sample_source_id: '40', env_source_name: 'human associated'},
{env_sample_source_id: '45', env_source_name: 'human-amniotic-fluid'},
{env_sample_source_id: '47', env_source_name: 'human-blood'},
{env_sample_source_id: '43', env_source_name: 'human-gut'},
{env_sample_source_id: '42', env_source_name: 'human-oral'},
{env_sample_source_id: '41', env_source_name: 'human-skin'},
{env_sample_source_id: '46', env_source_name: 'human-urine'},
{env_sample_source_id: '44', env_source_name: 'human-vaginal'},
{env_sample_source_id: '140', env_source_name: 'indoor'},
{env_sample_source_id: '50', env_source_name: 'microbial mat/biofilm'},
{env_sample_source_id: '60', env_source_name: 'miscellaneous_natural_or_artificial_environment'},
{env_sample_source_id: '70', env_source_name: 'plant associated'},
{env_sample_source_id: '80', env_source_name: 'sediment'},
{env_sample_source_id: '90', env_source_name: 'soil/sand'},
{env_sample_source_id: '100', env_source_name: 'unknown'},
{env_sample_source_id: '110', env_source_name: 'wastewater/sludge'},
{env_sample_source_id: '120', env_source_name: 'water-freshwater'},
{env_sample_source_id: '130', env_source_name: 'water-marine'}])