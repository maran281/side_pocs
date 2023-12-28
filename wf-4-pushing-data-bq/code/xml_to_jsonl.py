import json
import xmltodict

def xml_to_jsonl(xml_content):

    print("############# Inside xml_to_jsonl function #############")
    # parse xml to json dictionary
    data_dict = xmltodict.parse(xml_content)

    # extract relevent data structure from the dictionary
    catalog = data_dict.get('book', {})
    books = catalog if isinstance(catalog, list) else [catalog]

    # Convert each book to JSONL entry
    jsonl_entries = [json.dumps(book_var) for book_var in books]

    print(f"converted jsonl content is: {jsonl_entries}")
    
    print("############# exiting xml_to_jsonl function #############")

    return jsonl_entries