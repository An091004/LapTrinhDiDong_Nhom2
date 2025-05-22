using System.ComponentModel.DataAnnotations;

namespace api_expenes_flutter.Models
{
    public class CaiDat
    {
        [Key]
        public int MaCaiDat { get; set; }
        public int MaNguoiDung { get; set; }
        public bool CheDoToi { get; set; }
        public bool ThongBao { get; set; }
        
    }
    public class updateSettingRequest
    {
        public  bool? CheDoToi { set; get; }
        public  bool? ThongBao { get; set; }
    }
}
