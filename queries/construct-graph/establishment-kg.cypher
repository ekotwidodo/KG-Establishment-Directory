// ----- CONSTANTS -----//

CREATE CONSTRAINT FOR (e:Perusahaan) REQUIRE e.id IS UNIQUE;
CREATE CONSTRAINT FOR (p:Provinsi) REQUIRE p.kode IS UNIQUE;
CREATE CONSTRAINT FOR (r:Kabupaten_Kota) REQUIRE r.kode IS UNIQUE;
CREATE CONSTRAINT FOR (c:Kategori_KBLI) REQUIRE c.kode IS UNIQUE;
CREATE CONSTRAINT FOR (g:Golongan_Pokok_KBLI) REQUIRE g.kode IS UNIQUE;
CREATE CONSTRAINT FOR (k:Golongan_KBLI) REQUIRE k.kode IS UNIQUE;
CREATE CONSTRAINT FOR (s:Subgolongan_KBLI) REQUIRE s.kode IS UNIQUE;
CREATE CONSTRAINT FOR (b:Kelompok_KBLI) REQUIRE b.kode IS UNIQUE;

// ----- NODES -----//

// Load Perusahaan (Establishment)
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/ekotwidodo/establishment-directory-kg/main/datasets/establishments/perusahaan.csv' AS row
MERGE (e:Perusahaan {id: row.id})
SET e.nama = row.nama, e.alamat = row.alamat, e.latitude = toFloat(row.latitude), e.longitude = toFloat(row.longitude), e.telepon = row.telepon;

// Load Provinsi
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/ekotwidodo/establishment-directory-kg/main/datasets/regions/provinsi.csv' AS row
MERGE (p:Provinsi {kode: row.kode})
SET p.nama = row.nama;

// Load Kabupaten/Kota
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/ekotwidodo/establishment-directory-kg/main/datasets/regions/kabupaten.csv' AS row
MERGE (r:Kabupaten_Kota {kode: row.kode})
SET r.nama = row.nama;

// Load Kategori KBLI
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/ekotwidodo/establishment-directory-kg/main/datasets/kbli/kategori_kbli.csv' AS row
MERGE (c:Kategori_KBLI {kode: row.kode})
SET c.nama = row.nama, c.url = row.url;

// Load Golongan Pokok KBLI
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/ekotwidodo/establishment-directory-kg/main/datasets/kbli/golongan_pokok_kbli.csv' AS row
MERGE (g:Golongan_Pokok_KBLI {kode: row.kode})
SET g.nama = row.nama, g.url = row.url;

// Load Golongan KBLI
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/ekotwidodo/establishment-directory-kg/main/datasets/kbli/golongan_kbli.csv' AS row
MERGE (k:Golongan_KBLI {kode: row.kode})
SET k.nama = row.nama, k.url = row.url;

// Load Subgolongan KBLI
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/ekotwidodo/establishment-directory-kg/main/datasets/kbli/subgolongan_kbli.csv' AS row
MERGE (s:Subgolongan_KBLI {kode: row.kode})
SET s.nama = row.nama, s.url = row.url;

// Load Kelompok KBLI
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/ekotwidodo/establishment-directory-kg/main/datasets/kbli/kelompok_kbli.csv' AS row
MERGE (b:Kelompok_KBLI {kode: row.kode})
SET b.nama = row.nama, b.url = row.url;

// ----- RELATIONSHIPS -----//

// Relasi kabupaten/kota dengan provinsi
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/ekotwidodo/establishment-directory-kg/main/datasets/regions/relasi_kabupaten_provinsi.csv' AS row
MATCH (r:Kabupaten_Kota {kode: row.kabupaten_kode})
MATCH (p:Provinsi {kode: row.provinsi_kode})
MERGE (r)-[:TERLETAK_DI]->(p);

// Relasi perusahaan dengan kabupaten/kota
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/ekotwidodo/establishment-directory-kg/main/datasets/regions/relasi_perusahaan_kabupaten_provinsi.csv' AS row
MATCH (e:Perusahaan {id: row.id_perusahaan})
MATCH (r:Kabupaten_Kota {kode: row.kabupaten_kode})
MATCH (p:Provinsi {kode: row.provinsi_kode})
MERGE (e)-[:BERLOKASI_DI]->(r)
MERGE (e)-[:BERLOKASI_DI]->(p);

// Relasi perusahan dengan kelompok KBLI
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/ekotwidodo/establishment-directory-kg/main/datasets/kbli/relasi_perusahaan_kelompok_kbli.csv' AS row
MATCH (e:Perusahaan {id: row.id_perusahaan})
MATCH (b:Kelompok_KBLI {kode: row.kelompok_kbli_kode})
MERGE (e)-[:MEMILIKI_KELOMPOK_KBLI]->(b);

// Relasi kelompok KBLI dengan kategori KBLI
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/ekotwidodo/establishment-directory-kg/main/datasets/kbli/relasi_kelompok_kategori_kbli.csv' AS row
MATCH (b:Kelompok_KBLI {kode: row.kelompok_kbli_kode})
MATCH (c:Kategori_KBLI {kode: row.kategori_kbli_kode})
MERGE (b)-[:TERMASUK_KATEGORI]->(c);

// Relasi kelompok KBLI dengan golongan pokok KBLI
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/ekotwidodo/establishment-directory-kg/main/datasets/kbli/relasi_kelompok_golongan_pokok_kbli.csv' AS row
MATCH (b:Kelompok_KBLI {kode: row.kelompok_kbli_kode})
MATCH (g:Golongan_Pokok_KBLI {kode: row.golongan_pokok_kbli_kode})
MERGE (b)-[:TERMASUK_GOLONGAN_POKOK]->(g);

// Relasi kelompok KBLI dengan golongan KBLI
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/ekotwidodo/establishment-directory-kg/main/datasets/kbli/relasi_kelompok_golongan_kbli.csv' AS row
MATCH (b:Kelompok_KBLI {kode: row.kelompok_kbli_kode})
MATCH (k:Golongan_KBLI {kode: row.golongan_kbli_kode})
MERGE (b)-[:TERMASUK_GOLONGAN]->(k);

// Relasi kelompok KBLI dengan subgolongan KBLI
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/ekotwidodo/establishment-directory-kg/main/datasets/kbli/relasi_kelompok_subgolongan_kbli.csv' AS row
MATCH (b:Kelompok_KBLI {kode: row.kelompok_kbli_kode})
MATCH (s:Subgolongan_KBLI {kode: row.subgolongan_kbli_kode})
MERGE (b)-[:TERMASUK_SUBGOLONGAN]->(s);