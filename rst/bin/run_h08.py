import os
from src.simulation_loop import H08Run

def main():
    h08_run = H08Run()
    h08_run.run_single()
    
if __name__ == '__main__':
    print(os.getcwd())
    main()