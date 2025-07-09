# DBT Engineer Public

The official public repo with code examples mentioned in dbtengineer.com. 

## Local Development

### Prerequisites

1. Install docker desktop.



### How to generate fernet key

```sh
python3 -c "from cryptography.fernet import Fernet; print(Fernet.generate_key().decode())"
```

