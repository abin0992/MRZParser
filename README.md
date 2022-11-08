# Technical assignment for iOS SDK Engineer candidate 
## Introduction
A machine-readable passport (MRP) is a machine-readable travel document (MRTD) with the data on the identity page encoded in optical character recognition format called machine-readable zone (MRZ). More detailed explanation can be found at https://en.wikipedia.org/wiki/Machine-readable_passport or https://pypi.org/project/mrz/.

Some fields in the MRZ contain a check digit, for example document number or date of birth. A description and examples of the checksum calculation can be found at section 4.9 in https://www.icao.int/publications/Documents/9303_p3_cons_en.pdf.

## Assignment
- Develop solution which extracts and validates data from MRZ.
- To reduce time spent on assignment, we ask you to work with TD1 type and fields present in MrzInfo class, there is no need to add missing types or fields.

## Requirements
- Parse any given input string into fields of MrzInfo.
- Validate fields of MrzInfo.
- Make all unit tests pass. 

## Remarks:
- Please keep the solution in private repo.
- Don’t change public interface of classes so we can run extra unit tests on your solution.
- Keep in mind SOLID and design patterns to make solution scalable so it can easily be extended to support more types and more fields.
