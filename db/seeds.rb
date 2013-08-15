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