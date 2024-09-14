// ----- USE CASE ----- //

// Use Case 1
// Description: Daftar perusahaan yang terklasifikasi dalam kategori dan kelompok KBLI yang sama
MATCH (e:Perusahaan)-[r1:DIKLASIFIKASIKAN_SEBAGAI]->(b:Kelompok_KBLI)
MATCH (b)-[r2:TERMASUK_DALAM]->(c:Kategori_KBLI)
RETURN e,r1,b,r2,c;

// Use Case 2
// Description: Daftar perusahaan yang berlokasi di provinsi dan kabupaten/kota yang sama
MATCH (e:Perusahaan)-[r1:BERLOKASI_DI]->(m:Kabupaten_Kota)
MATCH (m)-[r2:TERDAPAT_DI]->(p:Provinsi)
RETURN e,r1,m,r2,p;

// Use Case 3
// Description: Pola penyebaran kelompok KBLI diantara provinsi yang bersebelahan
MATCH (p1:Provinsi)-[r1:BERSEBELAHAN_DENGAN]->(p2:Provinsi),
      (p1)<-[:BERLOKASI_DI]-(perusahaan1:Perusahaan)-[r2:DIKLASIFIKASIKAN_SEBAGAI]->(kbli:Kelompok_KBLI),
      (p2)<-[:BERLOKASI_DI]-(perusahaan2:Perusahaan)-[r3:DIKLASIFIKASIKAN_SEBAGAI]->(kbli)
RETURN *;

// Use Case 4
// Description: Daftar perusahaan yang tidak memiliki kelompok KBLI menurut Provinsi
MATCH (e:Perusahaan)
MATCH (e)-[r:BERLOKASI_DI]->(p:Provinsi)
WHERE NOT (e)-[:DIKLASIFIKASIKAN_SEBAGAI]->()
RETURN *;

// Use Case 5
// Description: Daftar perusahaan yang ada di sekitar lokasi tertentu berdasarkan koordinat Latitude dan Longitude
// Contoh LokasiSaya = Monumen Nasional: Latitude: -6.1753924 dan Longitude: 106.8271528
// Radius 5 km = 5000 m
WITH point({latitude: -6.1753924, longitude: 106.8271528}) AS LokasiSaya
MATCH (e:Perusahaan)
WHERE point.distance(point({latitude: toFloat(e.latitude), longitude: toFloat(e.longitude)}), LokasiSaya) <= 5000 // 5 km
WITH e, point({latitude: toFloat(e.latitude), longitude: toFloat(e.longitude)}) AS LokasiPerusahaan, LokasiSaya
MERGE (me:Lokasi {nama: "Lokasi Saya", koordinat: LokasiSaya})
MERGE (me)-[r:DEKAT_DENGAN {jarak: point.distance(LokasiPerusahaan, LokasiSaya)}]->(e)
RETURN *;

// ----- VALIDASI USE CASE ----- //

// Validasi Use Case 1
// Description: Daftar perusahaan yang terklasifikasi dalam kategori dan kelompok KBLI yang sama
MATCH (e:Perusahaan)-[r1:DIKLASIFIKASIKAN_SEBAGAI]->(b:Kelompok_KBLI)
MATCH (b)-[r2:TERMASUK_DALAM]->(c:Kategori_KBLI)
RETURN c.kode AS KodeKlasifikasi, c.nama AS NamaKlasifikasi, b.kode AS KodeKelompok, b.nama AS NamaKelompok, COUNT(e) AS JumlahPerusahaan
ORDER BY JumlahPerusahaan DESC;

// Validasi Use Case 2
// Description: Daftar perusahaan yang berlokasi di provinsi dan kabupaten/kota yang sama
MATCH (e:Perusahaan)-[r1:BERLOKASI_DI]->(p:Kabupaten_Kota)
MATCH (p)-[r2:TERDAPAT_DI]->(m:Provinsi)
RETURN m.kode AS KodeProv, m.nama AS NamaProv, p.kode AS KodeKako, p.nama AS NamaKako, COUNT(e) AS JumlahPerusahaan
ORDER BY JumlahPerusahaan DESC;

// Validasi Use Case 3
// Description: Pola penyebaran kelompok KBLI diantara provinsi yang bersebelahan
MATCH (p1:Provinsi)-[:BERSEBELAHAN_DENGAN]->(p2:Provinsi),
      (p1)<-[:BERLOKASI_DI]-(perusahaan1:Perusahaan)-[:DIKLASIFIKASIKAN_SEBAGAI]->(kbli:Kelompok_KBLI),
      (p2)<-[:BERLOKASI_DI]-(perusahaan2:Perusahaan)-[:DIKLASIFIKASIKAN_SEBAGAI]->(kbli)
RETURN p1.nama AS Provinsi1, p2.nama AS Provinsi2, kbli.nama AS KBLI, COUNT(perusahaan1) AS JumlahPerusahaan1, COUNT(perusahaan2) AS JumlahPerusahaan2
ORDER BY KBLI, Provinsi1, Provinsi2;

// Validasi Use Case 4
// Description: Daftar perusahaan yang tidak memiliki kelompok KBLI menurut Provinsi
MATCH (e:Perusahaan)
MATCH (e)-[r:BERLOKASI_DI]->(p:Provinsi)
WHERE NOT (e)-[:DIKLASIFIKASIKAN_SEBAGAI]->()
RETURN p.kode AS KodeProvinsi, p.nama AS NamaProvinsi, COUNT(e) AS JumlahPerusahaan
ORDER BY JumlahPerusahaan DESC;

// Validasi Use Case 5
// Description: Daftar perusahaan yang ada di sekitar lokasi tertentu berdasarkan koordinat Latitude dan Longitude
// Contoh LokasiSaya = Monumen Nasional: Latitude: -6.1753924 dan Longitude: 106.8271528
// Radius 5 km = 5000 m
WITH point({latitude: -6.1753924, longitude: 106.8271528}) AS LokasiSaya
MATCH (e:Perusahaan)
WHERE point.distance(point({latitude: toFloat(e.latitude), longitude: toFloat(e.longitude)}), LokasiSaya) <= 5000 // 5 km
RETURN e.nama AS NamaPerusahaan, e.alamat AS AlamatPerusahaan, e.latitude AS Latitude, e.longitude AS Longitude, point.distance(point({latitude: toFloat(e.latitude), longitude: toFloat(e.longitude)}), LokasiSaya) AS JarakPerusahaanKeLokasiSaya
ORDER BY JarakPerusahaanKeLokasiSaya;