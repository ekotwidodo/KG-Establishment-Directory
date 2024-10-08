// ----- CONSTANTS -----//

CREATE CONSTRAINT FOR (e:Perusahaan) REQUIRE e.id IS UNIQUE;
CREATE CONSTRAINT FOR (p:Provinsi) REQUIRE p.kode IS UNIQUE;
CREATE CONSTRAINT FOR (i:Pulau) REQUIRE i.nama IS UNIQUE;
CREATE CONSTRAINT FOR (m:Kabupaten_Kota) REQUIRE m.kode IS UNIQUE;
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
MERGE (m:Kabupaten_Kota {kode: row.kode})
SET m.nama = row.nama;

// Load Pulau
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/ekotwidodo/establishment-directory-kg/main/datasets/regions/pulau.csv' AS row
MERGE (i:Pulau {nama: row.pulau_nama});

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
MATCH (m:Kabupaten_Kota {kode: row.kabupaten_kode})
MATCH (p:Provinsi {kode: row.provinsi_kode})
MERGE (m)-[:TERDAPAT_DI]->(p);

// Relasi provinsi dengan pulau
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/ekotwidodo/establishment-directory-kg/main/datasets/regions/relasi_provinsi_pulau.csv' AS row
MATCH (p:Provinsi {kode: row.provinsi_kode})
MATCH (i:Pulau {nama: row.pulau})
MERGE (p)-[:TERLETAK_DI]->(i);

// Relasi provinsi bersebelahan dengan provinsi lain
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/ekotwidodo/establishment-directory-kg/main/datasets/regions/relasi_provinsi_bersebelahan.csv' AS row
MATCH (p1:Provinsi {kode: row.provinsi_kode})
MATCH (p2:Provinsi {kode: row.provinsi_tetangga})
MERGE (p1)-[:BERSEBELAHAN_DENGAN]->(p2);

// Relasi perusahaan dengan kabupaten/kota
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/ekotwidodo/establishment-directory-kg/main/datasets/regions/relasi_perusahaan_kabupaten_provinsi.csv' AS row
MATCH (e:Perusahaan {id: row.id_perusahaan})
MATCH (m:Kabupaten_Kota {kode: row.kabupaten_kode})
MATCH (p:Provinsi {kode: row.provinsi_kode})
MERGE (e)-[:BERLOKASI_DI]->(m)
MERGE (e)-[:BERLOKASI_DI]->(p);

// Relasi perusahan dengan kelompok KBLI
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/ekotwidodo/establishment-directory-kg/main/datasets/kbli/relasi_perusahaan_kelompok_kbli.csv' AS row
MATCH (e:Perusahaan {id: row.id_perusahaan})
MATCH (b:Kelompok_KBLI {kode: row.kelompok_kbli_kode})
MERGE (e)-[:DIKLASIFIKASIKAN_SEBAGAI]->(b);

// Relasi kelompok KBLI dengan kategori KBLI
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/ekotwidodo/establishment-directory-kg/main/datasets/kbli/relasi_kelompok_kategori_kbli.csv' AS row
MATCH (b:Kelompok_KBLI {kode: row.kelompok_kbli_kode})
MATCH (c:Kategori_KBLI {kode: row.kategori_kbli_kode})
MERGE (b)-[:TERMASUK_DALAM]->(c);

// Relasi kelompok KBLI dengan golongan pokok KBLI
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/ekotwidodo/establishment-directory-kg/main/datasets/kbli/relasi_kelompok_golongan_pokok_kbli.csv' AS row
MATCH (b:Kelompok_KBLI {kode: row.kelompok_kbli_kode})
MATCH (g:Golongan_Pokok_KBLI {kode: row.golongan_pokok_kbli_kode})
MERGE (b)-[:TERMASUK_DALAM]->(g);

// Relasi kelompok KBLI dengan golongan KBLI
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/ekotwidodo/establishment-directory-kg/main/datasets/kbli/relasi_kelompok_golongan_kbli.csv' AS row
MATCH (b:Kelompok_KBLI {kode: row.kelompok_kbli_kode})
MATCH (k:Golongan_KBLI {kode: row.golongan_kbli_kode})
MERGE (b)-[:TERMASUK_DALAM]->(k);

// Relasi kelompok KBLI dengan subgolongan KBLI
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/ekotwidodo/establishment-directory-kg/main/datasets/kbli/relasi_kelompok_subgolongan_kbli.csv' AS row
MATCH (b:Kelompok_KBLI {kode: row.kelompok_kbli_kode})
MATCH (s:Subgolongan_KBLI {kode: row.subgolongan_kbli_kode})
MERGE (b)-[:TERMASUK_DALAM]->(s);