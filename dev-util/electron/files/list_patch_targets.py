#!/usr/bin/env python

import argparse
import json


def parse_args():
  parser = argparse.ArgumentParser(description='Apply Electron patches')
  parser.add_argument('config', nargs='+',
                      type=argparse.FileType('r'),
                      help='patches\' config(s) in the JSON format')
  return parser.parse_args()


def main():
  configs = parse_args().config
  for config_json in configs:
    for i in json.load(config_json).iteritems():
      print("%s %s"% i)


if __name__ == '__main__':
  main()
