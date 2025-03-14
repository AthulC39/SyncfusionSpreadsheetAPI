using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Http;
using Syncfusion.EJ2.Spreadsheet;

namespace SpreadsheetService.Controllers
{
    [Route("api/spreadsheet")]
    [ApiController]
    public class SpreadsheetController : ControllerBase
    {
        // POST: api/spreadsheet/open
        [HttpPost("open")]
        public IActionResult Open([FromForm] IFormCollection openRequest)
        {
            // Create an instance of OpenRequest and assign the first uploaded file.
            OpenRequest open = new OpenRequest();
            open.File = openRequest.Files[0];

            // Use the XLSIO functionality to open the Excel file and convert it to JSON.
            string workbookJson = Workbook.Open(open);

            // Return the JSON string so the client (React Spreadsheet) can load it.
            return Content(workbookJson);
        }

        // POST: api/spreadsheet/save
         
       [HttpPost("save")]
        public IActionResult Save([FromForm] SaveSettings saveSettings)
        {
            // This method uses Syncfusion's Workbook.Save to process the workbook data.
            // It returns a file stream (FileContentResult) that the client can use to download the file.
            return Workbook.Save(saveSettings);
        }
    }
}
