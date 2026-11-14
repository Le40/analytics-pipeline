foreach (var column in Model.AllColumns)
{
    var name = column.Name.ToLowerInvariant();
    if (name.EndsWith("_id") || name.EndsWith("_key"))
    {
        column.SummarizeBy = AggregateFunction.None;
    }
}