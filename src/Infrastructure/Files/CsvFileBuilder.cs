using System.Globalization;
using LukeAPI.Application.Common.Interfaces;
using LukeAPI.Application.TodoLists.Queries.ExportTodos;
using LukeAPI.Infrastructure.Files.Maps;
using CsvHelper;

namespace LukeAPI.Infrastructure.Files;

public class CsvFileBuilder : ICsvFileBuilder
{
    public byte[] BuildTodoItemsFile(IEnumerable<TodoItemRecord> records)
    {
        using var memoryStream = new MemoryStream();
        using (var streamWriter = new StreamWriter(memoryStream))
        {
            using var csvWriter = new CsvWriter(streamWriter, CultureInfo.InvariantCulture);

            csvWriter.Configuration.RegisterClassMap<TodoItemRecordMap>();
            csvWriter.WriteRecords(records);
        }

        return memoryStream.ToArray();
    }
}
