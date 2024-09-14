# Kontruksi Graf Pengetahuan pada Direktori Perusahaan menggunakan Basis Data Graf Neo4j (_Construction of Establishment Directory Knowledge Graph using Graph Database Neo4j_)

## Tentang Penelitian

Penelitian ini mengangkat issue tentang kurangnya pemanfaatan direktori perusahaan. Repository ini merupakan implementasi dari konstruksi graf pengetahuan pada direktori perusahaan.

## Abstrak

Penelitian ini membahas pentingnya integrasi data direktori perusahaan di Indonesia melalui pendekatan graf pengetahuan (knowledge graph) menggunakan Neo4j. Direktori perusahaan, yang berisi informasi dasar seperti nama, alamat, dan kode Klasifikasi Baku Lapangan Usaha Indonesia (KBLI), sering kali tersebar dalam berbagai format dan sumber yang berbeda, sehingga menyulitkan analisis data yang komprehensif. Penelitian ini mengusulkan penggunaan graf pengetahuan sebagai solusi untuk mengatasi keterbatasan dalam integrasi data berbasis Relational Database Management System (RDBMS), dengan menonjolkan fleksibilitas dan efisiensi Neo4j dalam menangani data kompleks dan melakukan kueri yang intuitif. Studi kasus dalam penelitian ini menunjukkan bahwa graf pengetahuan dapat digunakan untuk mengidentifikasi pola dan hubungan signifikan antara entitas perusahaan, membantu dalam pemetaan industri, perencanaan ekonomi regional, serta mendukung pengambilan keputusan berbasis data. Meskipun demikian, penelitian ini juga mengidentifikasi beberapa tantangan dalam pengumpulan dan transformasi data, yang memerlukan penelitian lanjutan untuk meningkatkan penerapan graf pengetahuan di masa depan.

## Daftar Use Cases

Berikut ini adalah daftar use cases yang dilakukan pada penelitian ini:

1. Daftar perusahaan yang terklasifikasi dalam kategori dan kelompok KBLI yang sama
2. Daftar perusahaan yang berlokasi di provinsi dan kabupaten/kota yang sama
3. Pola penyebaran kelompok KBLI diantara provinsi yang bersebelahan
4. Daftar perusahaan yang tidak memiliki kelompok KBLI menurut Provinsi
5. Daftar perusahaan yang ada di sekitar lokasi tertentu berdasarkan koordinat Latitude dan Longitude

## How to Install

1. Buat environment

```bash
python -m venv venv
```

Aktivasi:

```bash
source venv/Scripts/activate # windows

source venv/bin/activate # mac/linux
```

2. Install dependencies

```bash
pip install -r requirements.txt

# update pip jika diperlukan
python.exe -m pip install --upgrade pip
```

3. Buat file `.env`

File `.env` berisi:

```bash
GOOGLE_API_KEY='your-google-api-key'
WEBAPI_BPS_API_KEY='your-web-api-key'
BASE_URL_KEMPERIN='your-base-url-kemenperin'
BASE_URL_WEBAPI_BPS='your-base-url-webapi-bps'
BASE_URL_KBLI_BPS='your-base-url-kbli-bps'
```

Jalankan `notebooks` terlebih dahulu untuk proses data scrapping dan data pre-processing. Kemudian, hasilnya akan beradata di folder `datasets` dimana nantinya akan dilakukan proses konstruksi graf pengetahuan melalui cypher query yang ada di folder `queries`. Gunakan AuraDB yang tersedia pada Neo4j atau bisa memanfaatkan Neo4j Desktop. Download hasil graf pengetahuan bisa disimpan ke dalam `dumps` apabila ingin mencoba tanpa harus melakukan pengaturan. Folder `schema` berisi arsitektur dan bagaimana pemodelan graf pengetahuan dibangun.

Alur:

`notebooks > datasets > queries > dumps`

```bash
NEO4J_URI='neo4j-uri'
NEO4J_USERNAME='neo4j-username'
NEO4J_PASSWORD='neo4j-password'
AURA_INSTANCEID='neo4j-instance-id'
AURA_INSTANCENAME='neo4j-instance-name'
```

## Tim Peneliti

- Yoga Cahya Putra
- Guruh Dewa Prataba
- Eko Teguh Widodo
