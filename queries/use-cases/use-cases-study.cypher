// ----- USE CASE ----- //

// Use Case 1
// Description: Daftar perusahaan yang mempunyai kelompok KBLI yang sama
MATCH (e:Perusahaan)-[r:MEMILIKI_KELOMPOK_KBLI]->(b:Kelompok_KBLI)
RETURN e,r,b;

// Use Case 2
// Description: Daftar perusahaan yang mempunyai kategori KBLI yang sama
MATCH (e:Perusahaan)-[r1:MEMILIKI_KELOMPOK_KBLI]->(b:Kelompok_KBLI)
MATCH (b)-[r2:MEMILIKI_KATEGORI]->(c:Kategori_KBLI)
RETURN e,r2,c;

// Use Case 3
// Description: Daftar perusahaan yang mempunyai golongan pokok KBLI yang sama
MATCH (e:Perusahaan)-[r1:MEMILIKI_KELOMPOK_KBLI]->(b:Kelompok_KBLI)
MATCH (b)-[r2:MEMILIKI_GOLONGAN_POKOK]->(g:Golongan_Pokok_KBLI)
RETURN e,r2,g;

// Use Case 4
// Description: Daftar perusahaan yang berada di provinsi yang sama
MATCH (e:Perusahaan)-[r1:BEROPERASI_DI]->(r:Kabupaten_Kota)
MATCH (r)-[r2:BERADA_DI]->(p:Provinsi)
RETURN e,r2,p;

// Use Case 5
// Description: Daftar perusahaan yang beroperasi di kabupaten/kota yang sama
MATCH (e:Perusahaan)-[r1:BEROPERASI_DI]->(r:Kabupaten_Kota)
RETURN e,r1,r;

// Use Case 6
// Description: Daftar perusahaan yang tidak memiliki kategori KBLI
MATCH (e:Perusahaan)
WHERE NOT (e)-[:MEMILIKI_KELOMPOK_KBLI]->(:Kelompok_KBLI)
RETURN e;

// Use Case 7
// Description: Pengecekan adanya duplikasi perusahaan berdasarkan nama, kabupaten, provinsi, dan kelompok KBLI
MATCH (e:Perusahaan)-[r1:BEROPERASI_DI]->(r:Kabupaten_Kota)
MATCH (r)-[r2:BERADA_DI]->(p:Provinsi)
MATCH (e)-[r3:MEMILIKI_KELOMPOK_KBLI]->(b:Kelompok_KBLI)
WITH e.nama AS NamaPerusahaan, r.kode AS KodeKabKota, p.kode AS KodeProv, b.kode AS KodeKelompokKBLI, COUNT(p) AS counter
WHERE counter > 1
RETURN NamaPerusahaan, counter AS JumlahDuplikasi;

// Use Case 8
// Description: Daftar perusahaan yang ada di sekitar lokasi tertentu berdasarkan koordinat Latitude dan Longitude
// Contoh LokasiSaya = Monumen Nasional: Latitude: -6.1753924 dan Longitude: 106.8271528
// Radius 5 km = 5000 m
WITH point({latitude: -6.1753924, longitude: 106.8271528}) AS LokasiSaya
MATCH (e:Perusahaan)
WHERE point.distance(point({latitude: toFloat(e.latitude), longitude: toFloat(e.longitude)}), LokasiSaya) <= 5000 // 5 km
RETURN e.nama AS NamaPerusahaan, e.latitude AS Latitude, e.longitude AS Longitude, point.distance(point({latitude: toFloat(e.latitude), longitude: toFloat(e.longitude)}), LokasiSaya) AS JarakPerusahaanKeLokasiSaya
ORDER BY JarakPerusahaanKeLokasiSaya;

// ----- VALIDASI USE CASE ----- //

// Validasi Use Case 1
// Description: Jumlah perusahaan menurut kelompok KBLI
MATCH (e:Perusahaan)-[r:MEMILIKI_KELOMPOK_KBLI]->(b:Kelompok_KBLI)
RETURN b.kode AS kelompok_kbli_kode, COUNT(e) AS JumlahPerusahaan
ORDER BY b.kode;

// Validasi Use Case 2
// Description: Jumlah perusahaan menurut kategori KBLI
MATCH (e:Perusahaan)-[r1:MEMILIKI_KELOMPOK_KBLI]->(b:Kelompok_KBLI)-[r2:MEMILIKI_KATEGORI]->(c:Kategori_KBLI)
RETURN c.kode AS Kode, c.nama AS NamaKategori, COUNT(e) AS JumlahPerusahaan
ORDER BY c.kode;

// Validasi Use Case 3
// Description: Jumlah perusahaan menurut golongan pokok KBLI
MATCH (e:Perusahaan)-[r1:MEMILIKI_KELOMPOK_KBLI]->(b:Kelompok_KBLI)-[r2:MEMILIKI_GOLONGAN_POKOK]->(g:Golongan_Pokok_KBLI)
RETURN g.kode AS Kode, g.nama AS NamaGolonganPokok, COUNT(e) AS JumlahPerusahaan
ORDER BY g.kode;

// Validasi Use Case 4
// Description: Jumlah perusahaan menurut provinsi
MATCH (e:Perusahaan)-[r1:BEROPERASI_DI]->(r:Kabupaten_Kota)-[r2:BERADA_DI]->(p:Provinsi)
RETURN p.kode AS Kode, p.nama AS NamaProvinsi, COUNT(e) AS JumlahPerusahaan
ORDER BY p.kode;

// Validasi Use Case 5
// Description: Jumlah perusahaan menurut kabupaten/kota
MATCH (e:Perusahaan)-[r1:BEROPERASI_DI]->(r:Kabupaten_Kota)
RETURN r.kode AS Kode, r.nama AS NamaKabKota, COUNT(e) AS JumlahPerusahaan
ORDER BY r.kode;