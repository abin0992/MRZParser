[![YourActionName Actions Status](https://github.com/abin0992/MRZParser/workflows/CI/badge.svg)](https://github.com/abin0992/MRZParser/actions) [![Build Status](https://github.com/abin0992/MRZParser/workflows/CI/badge.svg)](https://github.com/abin0992/MRZParser/actions)
## Introduction
A machine-readable passport (MRP) is a machine-readable travel document (MRTD) with the data on the identity page encoded in optical character recognition format called machine-readable zone (MRZ). More detailed explanation can be found at https://en.wikipedia.org/wiki/Machine-readable_passport or https://pypi.org/project/mrz/.

Some fields in the MRZ contain a check digit, for example document number or date of birth. A description and examples of the checksum calculation can be found at section 4.9 in https://www.icao.int/publications/Documents/9303_p3_cons_en.pdf.

## Features
- Parse any given input string into fields of MrzInfo.
- Validate fields of MrzInfo.
- Make all unit tests pass. 
