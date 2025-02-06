
const Map<String, Map<String, String>> languages = {
  "tr" : tr,
  "en" : en,
};

const Map<String, String> tr = {
  "anonymous_login" : "Misafir Olarak Devam Et",
  "pick_load" : "Yük Seç",
  "truck_post_details" : "Araç İlan Detayları",
  "propose" : "Teklif",
  "update_shipment_state" : "Nakliyat Durumunu Güncelle",
  "load_received" : "Yük Alındı",
  "target_reached" : "Hedefe Ulaşıldı",
  "load_delivered" : "Yük Teslim Edildi",
  "load_owner" : "Yük Sahibi",
  "this_shipment_is_canceled" : "Bu nakliyat iptal edildi!",
  "this_shipment_is_completed" : "Bu nakliyat tamamlandı.",
  "complete" : "Bitir",
  "error_cancel_shipment" : "Nakliyat iptal edilirken bir hata oluştu!",
  "success_cancel_shipment" : "Nakliyat başarıyla iptal edildi.",
  "details" : "Detaylar",
  "state" : "Durum",
  "load" : "Yükü",
  "oftruck" : "Aracı İle",
  "start" : "Nakliyat Başladı",
  "accepted" : "Kabul Edildi",
  "shipment_details" : "Nakliyat Detayları",
  "active_shipments" : "Aktif Nakliyatlar",
  "success_creating_shipment" : "Nakliyat başarıyla oluşturuldu.",
  "error_creating_shipment" : "Nakliyat onaylanırken bir hata oluştu!",
  "you_have_accepted_this_offer" : "Bu teklifi kabul ettiniz!",
  "you_have_rejected_this_offer" : "Bu teklifi red ettiniz!",
  "sent" : "Teklif gönderildi",
  "offers" : "Teklifler",
  "show_offers" : "Teklifleri Görüntüle",
  "now" : "Şimdi",
  "chat" : "Mesaj",
  "no_offer_found" : "Teklif görüntülenemiyor.",
  "no_shipment_found" : "Nakliyat görüntülenemiyor.",
  "who_sent" : "Teklifi Gönderen",
  "reject" : "Reddet",
  "success_accept_offer" : "Teklif kabul edildi.",
  "error_accept_offer" : "Teklif kabul edilemedi. Bilinmeyen bir hata oluştu.",
  "success_reject_offer" : "Teklif reddedildi.",
  "error_reject_offer" : "Teklif reddedilemedi. Bilinmeyen bir hata oluştu.",
  "no_places_found" : "Herhangi bir mekan bulunamadı.",
  "loading" : "Yükleniyor...",
  "send_a_message" : "Mesaj Gönder",
  "no_chats_found" : "Herhangi bir mesaj bulunmadı.",
  "error_creating_chat" : "Mesajlarda bir sorun oluştu!",
  "error_creating_offer" : "Teklif gönderirken bir sorun oluştu!",
  "success_creating_offer" : "Teklif başarıyla gönderildi.",
  "offer_details" : "Teklif Detayları",
  "chats" : "Mesajlar",
  "show_results" : "Sonuçları Göster",
  "hide_results" : "Sonuçları Gizle",
  "pick_truck" : "Araç seç",
  "user_name" : "İletişim Adı",
  "user_details" : "İletişim Detayları",
  "upload" : "Yükle",
  "view" : "Görüntüle",
  "email" : "Email",
  "phone" : "Telefon",
  "password" : "Şifre",
  "password_again" : "Şifre Tekrar",
  "forgot_password" : "Şifremi Unuttum",
  "login" : "Giriş Yap",
  "or" : "ya da",
  "user_agreement" : " Kullanıcı Sözleşmesi",
  "by_continuing" : "Devam ederek",
  "accepted_user_agreement" : "'ni kabul etmiş olacaksınız.",
  "sign_up" : "Kayıt Ol",
  "already_have_account" : "Zaten hesabım var",
  "no_account" : "Hesabım yok",
  "add_photo" : "Fotoğraf ekle",
  "name" : "İsim",
  "surname" : "Soyisim",
  "continue" : "Devam Et",
  "pick_role" : "Bir Rol Seçiniz",
  "carrier" : "Taşıyıcı",
  "shipper" : "Yük Sahibi",
  "license_front" : "Ehliyet Ön Yüz",
  "license_back" : "Ehliyet Arka Yüz",
  "id_front" : "Kimlik Ön Yüz",
  "id_back" : "Kimlik Arka Yüz",
  "src" : "SRC belgenizi yükleyiniz",
  "psiko" : "Psikoteknik belgenizi yükleyiniz",
  "confirm" : "Onayla",
  "input_email" : "Email adresinizi giriniz.",
  "input_password" : "Şifrenizi giriniz.",
  "input_password_again" : "Şifrenizi tekrar giriniz.",
  "input_phone" : "Telefon numaranızı giriniz.",
  "input_name" : "İsminizi giriniz.",
  "input_surname" : "Soyisminizi giriniz.",
  "upload_necessary_files" : "Gerekli Dosyaları Yükleyiniz",
  "fill_out" : "Bilgilerinizi Giriniz",
  "search" : "Arama Yap",
  "discover" : "Keşfet",
  "find_load" : "Yük Bul",
  "find_loads" : "Yükleri Bul",
  "rest" : "Dinlen",
  "fuel" : "Yakıt Bul",
  "my_vehicles" : "Araçlarım",
  "new_vehicle" : "Yeni Araç Ekle",
  "new_post_with_vehicle" : "Araç için yeni ilan ekle",
  "add_new_truck" : "Yeni Araç Ekle",
  "save" : "Kaydet",
  "length" : "Uzunluk",
  "weight" : "Ağırlık",
  "price" : "Fiyat",
  "equipment_limits" : "Yük Sınırı",
  "full" : "Tam",
  "partial" : "Kısmi",
  "truck_name" : "Araç İsmi",
  "enter_truck_name" : "Araç ismi giriniz.",
  "enter_trailer_name" : "Dorse ismi giriniz.",
  "enter_description" : "Bir açıklama yazınız",
  "enter_load" : "Yükünüzü ekleyin.",
  "enter_truck_post" : "Aracınızı ilana verin.",
  "description" : "Açıklama",
  "enter_truck_description" : "Araç için bir açıklama yazınız.",
  "truck_details" : "Araç Detayları",
  "origin" : "Başlangıç",
  "target" : "Hedef",
  "vehicle_type" : "Araç Türü",
  "start_date" : "Başlangıç Tarihi",
  "end_date" : "Bitiş Tarihi",
  "pick_a_date" : "Bir tarih seçiniz",
  "max_age" : "Max. Yayın Tarihi",
  "published_date" : "Yayın Tarihi",
  "pick_a_type" : "Araç Türü Seçiniz",
  "pick_an_age" : "Maksimum bir yayın tarihi seçiniz",
  "cancel" : "İptal",
  "result" : "Sonuç",
  "edit_search" : "Aramayı Düzenle",
  "request_sent" : "İstek Gönderildi",
  "est" : "Ort.",
  "load_details" : "Yük Detayları",
  "take_the_job" : "İşi Al",
  "call" : "Ara",
  "total" : "Toplam",
  "distance" : "Mesafe",
  "vehicle_details" : "Araç Detayları",
  "shipping_details" : "Nakliye Detayları",
  "rate_details" : "Fiyatlandırma Detayları",
  "company_details" : "Şirket Detayları",
  "full_partial" : "Tam/Kısmi",
  "shipping_type" : "Yük Türü",
  "pick_up_date" : "Teslim Alma",
  "dock_date" : "Teslim Etme",
  "reference" : "Referans Kodu",
  "per_km" : "KM Başına",
  "company_name" : "Şirket İsmi",
  "location" : "Konum",
  "rating" : "Değerlendirme",
  "registration" : "Ruhsat belgenizi yükleyiniz",
  "i_am_a_broker" : "Nakliye komisyoncusuyum.\nYük sahibi değilim.",
  "i_am_a_carrier" : "Yük taşıyıcısıyım.\nYük sahibi değilim.",
  "i_am_a_shipper" : "Yük sahibiyim.",
  "my_loads" : "Yüklerim",
  "new_post" : "Yeni Yük Oluştur",
  "start_time" : "Alma Saati",
  "end_time" : "Teslim Saati",
  "pick_a_time" : "Bir saat seçiniz",
  "contact_phone" : "İletişim Numarası",
  "enter_contact_phone" : "Bir iletişim numarası giriniz",
  "enter_price" : "Bir fiyat giriniz",
  "post_your_car" : "Aracı Yayınla",
  "registered_city" : "Kayıtlı Olduğu Şehir",
  "enter_registered_city" : "Aracıın kayıtlı olduğu şehri seçiniz",
  "bulk_or_palletized" : "Yük Dökmeli mi Paletli mi?",
  "bulk" : "Dökmeli",
  "palletized" : "Paletli",
  "load_type" : "Yük Tipi",
  "post_new_load" : "Yeni Yük Oluştur",
  "load_volume" : "Yük Hacmi",
  "problem_signing_up" : "Kayıt sırasında bir hata oluştu!",
  "problem_creating_new_load" : "Yeni yük eklenirken bir hata oluştu!",
  "new_load_created" : "Yeni yük başarıyla listelendi.",
  "problem_creating_new_truck_post" : "Yeni araç ilanı eklenirken bir hata oluştu!",
  "new_truck_post_created" : "Yeni araç ilanı başarıyla listelendi.",
  "success_creating_truck" : "Yeni araç başarıyla eklendi.",
  "success_editing_truck" : "Araç başarıyla güncellendi.",
  "error_editing_truck" : "Araç güncellenirken sorun oluştu!",
  "error_creating_truck" : "Yeni araç eklenirken bir hata oluştu!.",
  "enter_weight" : "Ağırlık giriniz.",
  "enter_length" : "Uzunluk giriniz.",
  "enter_volume" : "Hacim giriniz.",
  "volume" : "Hacim",
  "end_date_must_be_after_than_first_date" : "Bitiş tarihi başlangıç tarihi ile aynı gün veya sonrasında olmalıdır.",
  "bus" : "Otobüs",
  "truck" : "Kamyon",
  "car" : "Araba",
  "pick_a_phone_number" : "Bir iletişim numarası seçiniz",
  "add_new_phone_number" : "Yeni numara ekle",
  "available" : "Aktif",
  "no_loads_found" : "Henüz bir yük eklemediniz. Yeni bir yük oluşturabilirsiniz.",
  "my_truck_has_trailer" : "Aracımda dorse bulunuyor.",
  "trailer_details" : "Dorse Detayları",
  "trailer_name" : "Dorse İsmi",
  "trailer_tooltip" : "Dorse bilgilerini araç toplamını dahil etmeden giriniz.",
  "pick_existing_trailers" : "Mevcut Dorse Seç",
  "search_places" : "Arama yap",
  "delete_load_content" : "Seçilen yükü silmeniz durumunda bütün bilgileriyle kaldırılır.",
  "delete_offer_content" : "Seçilen teklifi silmeniz durumunda bütün bilgileriyle kaldırılır.",
  "delete_truck_content" : "Seçilen aracı silmeniz durumunda bütün bilgileriyle kaldırılır.",
  "delete_truck_post_content" : "Seçilen araç ilanını silmeniz durumunda bütün bilgileriyle kaldırılır.",
  "delete_load_title" : "Seçilen yükü silmek istediğinize emin misiniz?",
  "delete_offer_title" : "Seçilen teklifi silmek istediğinize emin misiniz?",
  "delete_truck_title" : "Seçilen aracı silmek istediğinize emin misiniz?",
  "delete_truck_post_title" : "Seçilen araç ilanını silmek istediğinize emin misiniz?",
  "offer_deleted_succesfully" : "Teklif başarıyla kaldırıldı.",
  "truck_deleted_succesfully" : "Araç başarıyla kaldırıldı.",
  "truck_post_deleted_succesfully" : "Araç ilanı başarıyla kaldırıldı.",
  "edit_truck" : "Aracı Düzenle",
  "my_truck_posts" : "Araç İlanlarım",
  "my_profile" : "Profilim",
  "broker" : "Nakliye Komisyoncusu",
  "contacts" : "İletişim Hatları",
  "languages" : "Diller",
  "theme" : "Tema",
  "files" : "Kayıtlı Belgeler",
  "delete_your_account" : "Hesabını sil",
  "logout" : "Çıkış yap",
  "edit_profile" : "Profili Düzenle",
  "error_editing_user" : "Profil düzenlenirken bir hata oluştu!.",
  "success_editing_user" : "Profil başarıyla güncellendi!.",
  "camera" : "Kamera",
  "gallery" : "Galeri",
  "may_delete_after_login" : "Yeniden giriş yaptıktan sonra hesabınızı silebilirsiniz.",
  "switch_language" : "Dili Değiştir",
  "error_complete_shipment" : "Nakliyat tamamlanırken bir hata oluştu!",
  "success_complete_shipment" : "Nakliyat başarıyla tamamlandı.",
  "completed" : "Tamamlandı",
  "canceled" : "İptal Edildi",
  "you_need_a_profile" : "Herhangi bir işlem için kayıt olmalısınız.",
};
const Map<String, String> en = {
  "anonymous_login" : "Misafir Olarak Devam Et",
  "you_need_a_profile" : "Herhangi bir işlem için kayıt olmalısınız.",
  "pick_load" : "Yük Seç",
  "truck_post_details" : "Araç İlan Detayları",
  "propose" : "Teklif",
  "update_shipment_state" : "Nakliyat Durumunu Güncelle",
  "load_received" : "Yük Alındı",
  "target_reached" : "Hedefe Ulaşıldı",
  "load_delivered" : "Yük Teslim Edildi",
  "load_owner" : "Yük Sahibi",

  "completed" : "Tamamlandı",
  "canceled" : "İptal Edildi",
  "complete" : "Bitir",
  "this_shipment_is_canceled" : "Bu nakliyat iptal edildi!",
  "this_shipment_is_completed" : "Bu nakliyat tamamlandı.",
  "error_cancel_shipment" : "Nakliyat iptal edilirken bir hata oluştu!",
  "success_cancel_shipment" : "Nakliyat başarıyla iptal edildi.",
  "error_complete_shipment" : "Nakliyat tamamlanırken bir hata oluştu!",
  "success_complete_shipment" : "Nakliyat başarıyla tamamlandı.",
  "state" : "State",
  "details" : "Details",
  "start" : "Nakliyat Başladı",
  "load" : "'s load",
  "oftruck" : "'s truck",
  "shipment_details" : "Nakliyat Detayları",
  "accepted" : "Kabul Edildi",

  "active_shipments" : "Aktif Nakliyatlar",
  "no_shipment_found" : "Nakliyat görüntülenemiyor.",

  "success_creating_shipment" : "Nakliyat başarıyla oluşturuldu.",
  "error_creating_shipment" : "Nakliyat onaylanırken bir hata oluştu!",
  "now" : "Now",
  "offers" : "Offers",
  "you_have_accepted_this_offer" : "Bu teklifi kabul ettiniz!",
  "you_have_rejected_this_offer" : "Bu teklifi red ettiniz!",
  "no_offer_found" : "Teklif görüntülenemiyor.",
  "chat" : "Chat",
  "show_offers" : "View Offers",
  "who_sent" : "Teklifi Gönderen",
  "reject" : "Reddet",
  "success_accept_offer" : "Teklif kabul edildi.",
  "error_accept_offer" : "Teklif kabul edilemedi. Bilinmeyen bir hata oluştu.",
  "success_reject_offer" : "Teklif reddedildi.",
  "error_reject_offer" : "Teklif reddedilemedi. Bilinmeyen bir hata oluştu.",
  "delete_offer_content" : "Seçilen teklifi silmeniz durumunda bütün bilgileriyle kaldırılır.",
  "delete_offer_title" : "Seçilen teklifi silmek istediğinize emin misiniz?",
  "offer_deleted_succesfully" : "Teklif başarıyla kaldırıldı.",
  "error_creating_offer" : "An error occured while sending an offer!",
  "success_creating_offer" : "Offer sent successfully",
  "offer_details" : "Offer Details",
  "send_a_message" : "Send a Message",
  "no_places_found" : "No places found.",
  "loading" : "Loading...",
  "chats" : "Chats",
  "no_chats_found" : "No chats found",
  "show_results" : "Show Results",
  "hide_results" : "Hide Results",
  "email" : "Email",
  "phone" : "Telefon",
  "password" : "Şifre",
  "password_again" : "Şifre Tekrar",
  "forgot_password" : "Şifremi Unuttum",
  "login" : "Giriş Yap",
  "or" : "ya da",
  "user_agreement" : " Kullanıcı Sözleşmesi",
  "by_continuing" : "Devam ederek",
  "accepted_user_agreement" : "'ni kabul etmiş olacaksınız.",
  "sign_up" : "Kayıt Ol",
  "already_have_account" : "Zaten hesabım var",
  "no_account" : "Hesabım yok",
  "add_photo" : "Fotoğraf ekle",
  "name" : "İsim",
  "surname" : "Soyisim",
  "continue" : "Devam Et",
  "pick_role" : "Bir Rol Seçiniz",
  "carrier" : "Taşıyıcı",
  "shipper" : "Yük Sahibi",
  "license_front" : "Ehliyet Ön Yüz",
  "license_back" : "Ehliyet Arka Yüz",
  "id_front" : "Kimlik Ön Yüz",
  "id_back" : "Kimlik Arka Yüz",
  "src" : "SRC belgenizi yükleyiniz",
  "psiko" : "Psikoteknik belgenizi yükleyiniz",
  "confirm" : "Onayla",
  "input_email" : "Email adresinizi giriniz.",
  "input_password" : "Şifrenizi giriniz.",
  "input_password_again" : "Şifrenizi tekrar giriniz.",
  "input_phone" : "Telefon numaranızı giriniz.",
  "input_name" : "İsminizi giriniz.",
  "input_surname" : "Soyisminizi giriniz.",
  "upload_necessary_files" : "Gerekli Dosyaları Yükleyiniz",
  "fill_out" : "Bilgilerinizi Giriniz",
  "search" : "Arama Yap",
  "discover" : "Keşfet",
  "find_load" : "Yük Bul",
  "find_loads" : "Yükleri Bul",
  "rest" : "Dinlen",
  "fuel" : "Yakıt Bul",
  "my_vehicles" : "Araçlarım",
  "new_vehicle" : "Yeni Araç Ekle",
  "new_post_with_vehicle" : "Araç için yeni ilan ekle",
  "add_new_truck" : "Yeni Araç Ekle",
  "save" : "Kaydet",
  "length" : "Uzunluk",
  "weight" : "Ağırlık",
  "price" : "Fiyat",
  "equipment_limits" : "Yük Sınırı",
  "full" : "Tam",
  "partial" : "Kısmi",
  "truck_name" : "Araç İsmi",
  "enter_truck_name" : "Araç ismi giriniz.",
  "enter_trailer_name" : "Dorse ismi giriniz.",
  "enter_description" : "Bir açıklama yazınız",
  "description" : "Açıklama",
  "enter_truck_description" : "Araç için bir açıklama yazınız.",
  "truck_details" : "Araç Detayları",
  "origin" : "Başlangıç",
  "target" : "Hedef",
  "vehicle_type" : "Araç Türü",
  "start_date" : "Başlangıç Tarihi",
  "end_date" : "Bitiş Tarihi",
  "pick_a_date" : "Bir tarih seçiniz",
  "max_age" : "Max. Yayın Tarihi",
  "published_date" : "Yayın Tarihi",
  "pick_a_type" : "Araç Türü Seçiniz",
  "pick_an_age" : "Maksimum bir yayın tarihi seçiniz",
  "cancel" : "İptal",
  "result" : "Sonuç",
  "edit_search" : "Aramayı Düzenle",
  "request_sent" : "İstek Gönderildi",
  "est" : "Ort.",
  "load_details" : "Yük Detayları",
  "take_the_job" : "İşi Al",
  "call" : "Ara",
  "total" : "Toplam",
  "distance" : "Mesafe",
  "vehicle_details" : "Araç Detayları",
  "shipping_details" : "Nakliye Detayları",
  "rate_details" : "Fiyatlandırma Detayları",
  "company_details" : "Şirket Detayları",
  "full_partial" : "Tam/Kısmi",
  "shipping_type" : "Yük Türü",
  "pick_up_date" : "Teslim Alma",
  "dock_date" : "Teslim Etme",
  "reference" : "Referans Kodu",
  "per_km" : "KM Başına",
  "company_name" : "Şirket İsmi",
  "location" : "Konum",
  "rating" : "Değerlendirme",
  "registration" : "Ruhsat belgenizi yükleyiniz",
  "i_am_a_broker" : "Nakliye komisyoncusuyum.\nYük sahibi değilim.",
  "i_am_a_carrier" : "Yük taşıyıcısıyım.\nYük sahibi değilim.",
  "i_am_a_shipper" : "Yük sahibiyim.",
  "my_loads" : "Yüklerim",
  "new_post" : "Yeni Yük Oluştur",
  "start_time" : "Alma Saati",
  "end_time" : "Teslim Saati",
  "pick_a_time" : "Bir saat seçiniz",
  "contact_phone" : "İletişim Numarası",
  "enter_contact_phone" : "Bir iletişim numarası giriniz",
  "enter_price" : "Bir fiyat giriniz",
  "post_your_car" : "Aracı Yayınla",
  "registered_city" : "Kayıtlı Olduğu Şehir",
  "enter_registered_city" : "Aracıın kayıtlı olduğu şehri seçiniz",
  "bulk_or_palletized" : "Yük Dökmeli mi Paletli mi?",
  "bulk" : "Dökmeli",
  "palletized" : "Paletli",
  "load_type" : "Yük Tipi",
  "post_new_load" : "Yeni Yük Oluştur",
  "load_volume" : "Yük Hacmi",
  "problem_signing_up" : "Kayıt sırasında bir hata oluştu!",
  "problem_creating_new_load" : "Yeni yük eklenirken bir hata oluştu!",
  "new_load_created" : "Yeni yük başarıyla listelendi.",
  "problem_creating_new_truck_post" : "Yeni araç ilanı eklenirken bir hata oluştu!",
  "new_truck_post_created" : "Yeni araç ilanı başarıyla listelendi.",
  "success_creating_truck" : "Yeni araç başarıyla eklendi.",
  "success_editing_truck" : "Araç başarıyla güncellendi.",
  "error_editing_truck" : "Araç güncellenirken sorun oluştu!",
  "error_creating_truck" : "Yeni araç eklenirken bir hata oluştu!.",
  "enter_weight" : "Ağırlık giriniz.",
  "enter_length" : "Uzunluk giriniz.",
  "enter_volume" : "Hacim giriniz.",
  "volume" : "Hacim",
  "end_date_must_be_after_than_first_date" : "Bitiş tarihi başlangıç tarihi ile aynı gün veya sonrasında olmalıdır.",
  "bus" : "Otobüs",
  "truck" : "Kamyon",
  "car" : "Araba",
  "pick_a_phone_number" : "Bir iletişim numarası seçiniz",
  "add_new_phone_number" : "Yeni numara ekle",
  "available" : "Aktif",
  "no_loads_found" : "Henüz bir yük eklemediniz. Yeni bir yük oluşturabilirsiniz.",
  "my_truck_has_trailer" : "Aracımda dorse bulunuyor.",
  "trailer_details" : "Dorse Detayları",
  "trailer_name" : "Dorse İsmi",
  "trailer_tooltip" : "Dorse bilgilerini araç toplamını dahil etmeden giriniz.",
  "pick_existing_trailers" : "Mevcut Dorse Seç",
  "search_places" : "Arama yap",
  "delete_load_content" : "Seçilen yükü silmeniz durumunda bütün bilgileriyle kaldırılır.",
  "delete_truck_content" : "Seçilen aracı silmeniz durumunda bütün bilgileriyle kaldırılır.",
  "delete_truck_post_content" : "Seçilen araç ilanını silmeniz durumunda bütün bilgileriyle kaldırılır.",
  "delete_load_title" : "Seçilen yükü silmek istediğinize emin misiniz?",
  "delete_truck_title" : "Seçilen aracı silmek istediğinize emin misiniz?",
  "delete_truck_post_title" : "Seçilen araç ilanını silmek istediğinize emin misiniz?",
  "load_deleted_succesfully" : "Yük başarıyla kaldırıldı.",
  "truck_deleted_succesfully" : "Araç başarıyla kaldırıldı.",
  "truck_post_deleted_succesfully" : "Araç ilanı başarıyla kaldırıldı.",
  "edit_truck" : "Aracı Düzenle",
  "my_truck_posts" : "Araç İlanlarım",
  "my_profile" : "Profilim",
  "broker" : "Nakliye Komisyoncusu",
  "contacts" : "İletişim Hatları",
  "languages" : "Diller",
  "theme" : "Tema",
  "files" : "Kayıtlı Belgeler",
  "delete_your_account" : "Hesabını sil",
  "logout" : "Çıkış yap",
  "edit_profile" : "Profili Düzenle",
  "error_editing_user" : "Profil düzenlenirken bir hata oluştu!.",
  "success_editing_user" : "Profil başarıyla güncellendi!.",
  "camera" : "Kamera",
  "gallery" : "Galeri",
  "may_delete_after_login" : "Yeniden giriş yaptıktan sonra hesabınızı silebilirsiniz.",
  "switch_language" : "Dili Değiştir",
};