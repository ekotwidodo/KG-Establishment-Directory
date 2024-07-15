// Use Case 1a
// Description: Daftar perusahaan yang mempunyai kode KBLI yang sama
MATCH (p:Perusahaan)-[r:HAS_KODE_KBLI]->(k:KBLI)
RETURN p,r,k;

// Use Case 1b
// Description: Jumlah perusahaan menurut kode KBLI
MATCH (p:Perusahaan)-[r:HAS_KODE_KBLI]->(k:KBLI)
RETURN k.kbli AS KBLI, COUNT(p) AS JumlahPerusahaan
ORDER BY k.kbli;

// Use Case 2a
// Description: Daftar perusahaan yang mempunyai kategori KBLI yang sama
MATCH (p:Perusahaan)-[r:HAS_KATEGORI_KBLI]->(k:KategoriKBLI)
RETURN p,r,k;

// Use Case 2b
// Description: Jumlah perusahaan menurut kategori KBLI
MATCH (p:Perusahaan)-[r:HAS_KATEGORI_KBLI]->(k:KategoriKBLI)
RETURN k.kategori_id AS Kode, k.kategori_nama AS NamaKategori, COUNT(p) AS JumlahPerusahaan
ORDER BY k.kategori_id;

// Use Case 3a
// Description: Daftar perusahaan yang mempunyai golongan KBLI yang sama
MATCH (p:Perusahaan)-[r:HAS_GOLONGAN_KBLI]->(k:GolonganKBLI)
RETURN p,r,k;

// Use Case 3b
// Description: Jumlah perusahaan menurut Golongan Pokok KBLI
MATCH (p:Perusahaan)-[r:HAS_GOLONGAN_KBLI]->(k:GolonganKBLI)
RETURN k.golongan_id AS Kode, k.golongan_nama AS NamaGolonganPokok, COUNT(p) AS JumlahPerusahaan
ORDER BY k.golongan_id;

// Use Case 4a
// Description: Daftar perusahaan yang berada di provinsi yang sama
MATCH (p:Perusahaan)-[r:HAS_PROVINSI]->(k:Provinsi)
RETURN p,k,r;

// Use Case 4b
// Description: Jumlah perusahaan menurut provinsi
MATCH (p:Perusahaan)-[r:HAS_PROVINSI]->(k:Provinsi)
RETURN k.prov_id AS Kode, k.prov_nama AS NamaProvinsi, COUNT(p) AS JumlahPerusahaan
ORDER BY k.prov_id;

// Use Case 5a
// Description: Daftar perusahaan yang berada di kabupaten/kota yang sama
MATCH (p:Perusahaan)-[r:HAS_KAKO]->(k:KabupatenKota)
RETURN p,k,r;

// Use Case 5b
// Description: Jumlah perusahaan menurut kabupaten/kota
MATCH (p:Perusahaan)-[r:HAS_KAKO]->(k:KabupatenKota)
RETURN k.kako_id AS Kode, k.kako_nama AS NamaKabKota, COUNT(p) AS JumlahPerusahaan
ORDER BY k.kako_id;

// Use Case 6
// Description: Daftar perusahaan yang tidak memiliki kode KBLI
MATCH (p:Perusahaan)
WHERE NOT (p)-[:HAS_KODE_KBLI]->(:KBLI)
RETURN p;

// Use Case 7
// Description: Pengecekan adanya duplikasi perusahaan berdasarkan nama, kabupaten, provinsi, dan kode KBLI
MATCH (p:Perusahaan)
WITH p.nama AS NamaPerusahaan, p.kako_id AS KodeKabKota, p.prov_id AS KodeProv, p.kbli AS KodeKBLI, COUNT(p) AS counter
WHERE counter > 1
RETURN NamaPerusahaan, counter AS JumlahDuplikasi;

// Use Case 8
// Description: Daftar perusahaan yang ada di sekitar lokasi tertentu berdasarkan koordinat Latitude dan Longitude
// Contoh LokasiSaya = Monumen Nasional: Latitude: -6.1753924 dan Longitude: 106.8271528
// Radius 5 km = 5000 m
WITH point({latitude: -6.1753924, longitude: 106.8271528}) AS LokasiSaya
MATCH (p:Perusahaan)
WHERE point.distance(point({latitude: toFloat(p.latitude), longitude: toFloat(p.longitude)}), LokasiSaya) <= 5000 // 5 km
RETURN p.nama AS NamaPerusahaan, p.latitude AS Latitude, p.longitude AS Longitude, point.distance(point({latitude: toFloat(p.latitude), longitude: toFloat(p.longitude)}), LokasiSaya) AS JarakPerusahaanKeLokasiSaya
ORDER BY JarakPerusahaanKeLokasiSaya;
