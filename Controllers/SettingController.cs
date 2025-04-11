using Microsoft.AspNetCore.Mvc;

namespace api_expenes_flutter.Controllers
{
    public class SettingController : Controller
    {
        public IActionResult Index()
        {
            return View();
        }
    }
}
