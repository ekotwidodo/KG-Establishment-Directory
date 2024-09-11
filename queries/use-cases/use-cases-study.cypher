// ----- USE CASE ----- //

// Use Case 1
// Description: Daftar perusahaan yang mempunyai kelompok KBLI yang sama
MATCH (e:Perusahaan)-[r:MEMILIKI_KELOMPOK_KBLI]->(b:Kelompok_KBLI)
RETURN e,r,b;

// Use Case 2
// Description: Daftar perusahaan yang mempunyai kategori KBLI yang sama
MATCH (e:Perusahaan)-[r1:MEMILIKI_KELOMPOK_KBLI]->(b:Kelompok_KBLI)
MATCH (b)-[r2:TERMASUK_KATEGORI]->(c:Kategori_KBLI)
RETURN e,r1,b,r2,c;

// Use Case 3
// Description: Daftar perusahaan yang mempunyai golongan pokok KBLI yang sama
MATCH (e:Perusahaan)-[r1:MEMILIKI_KELOMPOK_KBLI]->(b:Kelompok_KBLI)
MATCH (b)-[r2:TERMASUK_GOLONGAN_POKOK]->(g:Golongan_Pokok_KBLI)
RETURN e,r1,b,r2,g;

// Use Case 4
// Description: Daftar perusahaan yang berlokasi di provinsi yang sama
MATCH (e:Perusahaan)-[r:BERLOKASI_DI]->(p:Provinsi)
RETURN e,r,p;

// Use Case 5
// Description: Daftar perusahaan yang berlokasi di kabupaten/kota yang sama
MATCH (e:Perusahaan)-[r:BERLOKASI_DI]->(m:Kabupaten_Kota)
RETURN e,r,m;

// Use Case 6
// Description: Daftar perusahaan yang tidak memiliki kategori KBLI
MATCH (e:Perusahaan)
WHERE NOT (e)-[:MEMILIKI_KELOMPOK_KBLI]->()
RETURN e;

// Use Case 7
// Description: Pengecekan adanya duplikasi perusahaan berdasarkan nama, kabupaten, provinsi, dan kelompok KBLI
MATCH (e:Perusahaan)-[r1:BERLOKASI_DI]->(m:Kabupaten_Kota)
MATCH (e)-[r2:BERLOKASI_DI]->(p:Provinsi)
MATCH (e)-[r3:MEMILIKI_KELOMPOK_KBLI]->(b:Kelompok_KBLI)
WITH e.nama AS NamaPerusahaan, m.kode AS KodeKabKota, p.kode AS KodeProv, b.kode AS KodeKelompokKBLI, COUNT(p) AS counter
WHERE counter > 1
RETURN NamaPerusahaan, counter AS JumlahDuplikasi;

// Use Case 8
// Description: Daftar perusahaan yang ada di sekitar lokasi tertentu berdasarkan koordinat Latitude dan Longitude
// Contoh LokasiSaya = Monumen Nasional: Latitude: -6.1753924 dan Longitude: 106.8271528
// Radius 5 km = 5000 m
WITH point({latitude: -6.1753924, longitude: 106.8271528}) AS LokasiSaya
MATCH (e:Perusahaan)
WHERE point.distance(point({latitude: toFloat(e.latitude), longitude: toFloat(e.longitude)}), LokasiSaya) <= 5000 // 5 km
RETURN e.nama AS NamaPerusahaan, e.alamat AS AlamatPerusahaan, e.latitude AS Latitude, e.longitude AS Longitude, point.distance(point({latitude: toFloat(e.latitude), longitude: toFloat(e.longitude)}), LokasiSaya) AS JarakPerusahaanKeLokasiSaya
ORDER BY JarakPerusahaanKeLokasiSaya;

// ----- VALIDASI USE CASE ----- //

// Validasi Use Case 1
// Description: Jumlah perusahaan menurut kelompok KBLI
MATCH (e:Perusahaan)-[r:MEMILIKI_KELOMPOK_KBLI]->(b:Kelompok_KBLI)
RETURN b.kode AS KodeKelompok, b.nama AS NamaKelompok, COUNT(e) AS JumlahPerusahaan
ORDER BY JumlahPerusahaan DESC;

// Validasi Use Case 2
// Description: Jumlah perusahaan menurut kategori KBLI
MATCH (e:Perusahaan)-[r1:MEMILIKI_KELOMPOK_KBLI]->(b:Kelompok_KBLI)
MATCH (b)-[r2:TERMASUK_KATEGORI]->(c:Kategori_KBLI)
RETURN c.kode AS KodeKategori, c.nama AS NamaKategori, COUNT(e) AS JumlahPerusahaan
ORDER BY JumlahPerusahaan DESC;

// Validasi Use Case 3
// Description: Jumlah perusahaan menurut golongan pokok KBLI
MATCH (e:Perusahaan)-[r1:MEMILIKI_KELOMPOK_KBLI]->(b:Kelompok_KBLI)
MATCH (b)-[r2:TERMASUK_GOLONGAN_POKOK]->(g:Golongan_Pokok_KBLI)
RETURN g.kode AS KodeGolonganPokok, g.nama AS NamaGolonganPokok, COUNT(e) AS JumlahPerusahaan
ORDER BY JumlahPerusahaan DESC;

// Validasi Use Case 4
// Description: Jumlah perusahaan menurut provinsi
MATCH (e:Perusahaan)-[r:BERLOKASI_DI]->(p:Provinsi)
RETURN p.kode AS KodeProvinsi, p.nama AS NamaProvinsi, COUNT(e) AS JumlahPerusahaan
ORDER BY JumlahPerusahaan DESC;

// Validasi Use Case 5
// Description: Jumlah perusahaan menurut kabupaten/kota
MATCH (e:Perusahaan)-[r:BERLOKASI_DI]->(m:Kabupaten_Kota)
RETURN m.kode AS KodeKabKota, m.nama AS NamaKabKota, COUNT(e) AS JumlahPerusahaan
ORDER BY JumlahPerusahaan DESC;