// Use Case 1
// Description: Daftar perusahaan yang mempunyai kode KBLI yang sama
MATCH (p:Perusahaan)-[r:HAS_KODE_KBLI]->(k:KBLI)
RETURN p,r,k;

// Use Case 2
// Description: Daftar perusahaan yang mempunyai kategori KBLI yang sama
MATCH (p:Perusahaan)-[r:HAS_KATEGORI_KBLI]->(k:KategoriKBLI)
RETURN p,r,k;

// Use Case 3
// Description: Daftar perusahaan yang mempunyai golongan KBLI yang sama
MATCH (p:Perusahaan)-[r:HAS_GOLONGAN_KBLI]->(k:GolonganKBLI)
RETURN p,r,k;

// Use Case 4
// Description: Daftar perusahaan yang berada di provinsi yang sama
MATCH (p:Perusahaan)-[r:HAS_PROVINSI]->(k:Provinsi)
RETURN p,k,r;

// Use Case 5
// Description: Daftar perusahaan yang berada di kabupaten/kota yang sama
MATCH (p:Perusahaan)-[r:HAS_KAKO]->(k:KabupatenKota)
RETURN p,k,r;

// Use Case 6
// Description: Daftar perusahaan yang tidak memiliki kode KBLI
MATCH (p:Perusahaan)
WHERE p.kbli IS NULL or p.kbli = " "
RETURN p;

// Use Case 7
// Description: Jumlah perusahaan setiap provinsi
MATCH (p:Perusahaan)-[:HAS_PROVINSI]->(k:Provinsi)
RETURN k.prov_nama AS provinsi, COUNT(p) AS jumlah_perusahaan
ORDER BY jumlah_perusahaan DESC;
