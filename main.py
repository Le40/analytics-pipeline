from src.staging import staging_pipeline
from src.warehouse import warehouse_pipeline


def main() -> None:

    staging_pipeline.load_staging()
    warehouse_pipeline.load_warehouse()

if __name__ == "__main__":
    main()