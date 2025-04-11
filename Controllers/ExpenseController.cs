using Microsoft.AspNetCore.Mvc;

namespace api_expenes_flutter.Controllers
{
    public class ExpenseController : Controller
    {
        public IActionResult Index()
        {
            return View();
        }
    }
}
